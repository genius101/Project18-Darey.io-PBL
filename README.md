# Project18-Darey.io-PBL

## AUTOMATE INFRASTRUCTURE WITH IAC USING TERRAFORM. PART 3 – REFACTORING

In two previous projects you have developed AWS Infrastructure code using Terraform and tried to run it from your local workstation.

Now it is time to introduce some more advanced concepts and enhance your code.

We will explore alternative Terraform backends in this module

## Part 1 – Introducing Backend on S3

Each Terraform configuration can specify a backend, which defines where and how operations are performed, where state snapshots are stored, etc.

This is where terraform stores all the state of the infrastructure in json format.

So far, in our PART 1 and 2 we have been using the default backend, which is the <b>local backend</b> – it requires no configuration, and the states file is stored locally. This mode can be suitable for learning purposes, but it is not a robust solution, so it is better to store it in some more reliable and durable storage.

To achieve this we will need to configure a backend where the state file can be accessed remotely.

Since we are already using AWS – we can choose an S3 bucket as a backend.

Another useful option that is supported by S3 backend is State Locking – it is used to lock your state for all operations that could write state. This prevents others from acquiring the lock and potentially corrupting your state. State Locking feature for S3 backend is optional and requires another AWS service – DynamoDB.

Let us configure it!

Here is our plan to Re-initialize Terraform to use S3 backend:

- Add S3 and DynamoDB resource blocks before deleting the local state file

- Update terraform block to introduce backend and locking

- Re-initialize terraform

- Delete the local tfstate file and check the one in S3 bucket

- Add outputs

- terraform apply


Create a file and name it backend.tf. Add the below code and replace the name of the S3 bucket created in Project16-Darey.io-PBL( https://github.com/genius101/Project16-Darey.io-PBL)

    # Note: The bucket name may not work for you since buckets are unique globally in AWS, so you must give it a unique name.
    resource "aws_s3_bucket" "terraform_state" {
      bucket = "dev-terraform-bucket"
      # Enable versioning so we can see the full revision history of our state files
      versioning {
        enabled = true
      }
      # Enable server-side encryption by default
      server_side_encryption_configuration {
        rule {
          apply_server_side_encryption_by_default {
            sse_algorithm = "AES256"
          }
        }
      }
    }
    
Terraform stores secret data inside the state files. Passwords, and secret keys processed by resources are always stored in there.

Hence, you must consider to always enable encryption. You can see how we achieved that with server_side_encryption_configuration.

Next, we will create a DynamoDB table to handle locks and perform consistency checks. In previous projects, locks were handled with a local file as shown in terraform.tfstate.lock.info. Since we now have a team mindset, causing us to configure S3 as our backend to store state file, we will do the same to handle locking. 

Therefore, with a cloud storage database like DynamoDB, anyone running Terraform against the same infrastructure can use a central location to control a situation where Terraform is running at the same time from multiple different people.

Dynamo DB resource for locking and consistency checking:

    resource "aws_dynamodb_table" "terraform_locks" {
      name         = "terraform-locks"
      billing_mode = "PAY_PER_REQUEST"
      hash_key     = "LockID"
      attribute {
        name = "LockID"
        type = "S"
      }
    }

Terraform expects that both S3 bucket and DynamoDB resources are already created before we configure the backend. So, let us run terraform apply to provision resources.

Configure S3 Backend

    terraform {
      backend "s3" {
        bucket         = "dev-terraform-bucket"
        key            = "global/s3/terraform.tfstate"
        region         = "eu-central-1"
        dynamodb_table = "terraform-locks"
        encrypt        = true
      }
    }

Now its time to re-initialize the backend. Run terraform init and confirm you are happy to change the backend by typing yes

![terraform init](https://user-images.githubusercontent.com/10243139/138569797-af9761b6-1e0b-4f4a-b943-7a64fb8e2796.png)

Verify the changes

Before doing anything if you opened AWS now to see what happened you should be able to see the following:

- tfstatefile is now inside the S3 bucket

![Screenshot 2021-09-26 at 13 25 59](https://user-images.githubusercontent.com/10243139/138569854-19cb5089-2e37-4f7c-8c63-825280a44525.png)

- DynamoDB table which we create has an entry which includes state file status

![Screenshot 2021-09-26 at 13 26 54](https://user-images.githubusercontent.com/10243139/138569864-da04010a-5097-4bb3-9313-ecf830f60771.png)
