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


