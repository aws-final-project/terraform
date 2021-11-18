# Simple Autos AWS Deployment w/ Terraform
## Architecture Diagrams
[Original Plan](https://github.com/aws-final-project/terraform/blob/main/docs/firstdiagram.drawio.png)<br>
[Actual End Result](https://github.com/aws-final-project/terraform/blob/main/docs/finaldiagram.drawio.png)*

*not 100% finished...but 97% finished!

## Prompts
### The Team's Original Goals and How They Changed: 
Our original goal was to deploy Simple Autos with the simple React UI we had began back in Tier 3 via Terraform. We wanted to experiment with Lambdas originally, but we quickly pivoted once we started messing around with getting that set up. We decided on using an EC2 instance to clone our repo and run our API and another EC2 instance with Postgres installed to run our database. We tried to limit ourselves to what was the most reasonable amount we could expect to accomplish in this short time frame. We knew we wanted a public and a private subnet, with our API in the public one and our database in the private one. 

Our end product was very similar, except we did not deploy our UI due to time, but we also decided to experiment with Amazon RDS running Postgres instead of using an EC2 instance. We successfully deployed our code to EC2 and got it running and connected to our RDS instance. Most of this happened in Terraform, but the connection piece we achieved manually due to running out of time to programmatically create the IAM role needed to assign the EC2 permission to run the needed connection commands. 

### What We Learned
* SO MUCH BASH...like a lot. Mainly by bashing our heads against the computer screen. We got more familiar with different script commands and actions.
* How to set up subnets and security groups to allow a private RDS instance to communicate with a public API.
* How to use Terraform (duh).
* We explored hooking up our EC2 to a Heroku-hosted database too, which was cool.
* We learned about jq and how to use it to access values in an AWS CLI output.
* A lot about Linux commands!
* More about how to troubleshoot and documentation-hunt.
* Started to understand more about subnets, cidr blocks, and other networking principles.

### What we'd do next if given more time
We would finish out our script with our last couple commands. We manually were able to attach the IAM role to our EC2 to use the AWS CLI to retreive data, but we would have loved to be able to automate those commands in our install script if we had had the time. We had the commands manually to a) retreive our secret from AWS Secrets Manager, b) retrieve the dynamically-created host name for our RDS instance, and c) successfully start our API inputting the required environment variables. All that was missing was the IAM role creation in Terraform. Given another 3-4 hours we would probably have finished the whole automation process.
