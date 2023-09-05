# Creating a production ready AWS Instance using Terraform

## Initialise Remote State
Initialising remote state must be done separately, as the s3 bucket to hold your remote state must exist independently, to do this `cd` into `s3-dynamo` and use `terraform init` to initialize it, `terraform plan` to check your infra is correct and `terraform apply` to get it started.
-- This can be checked by navigating to your S3 bucket in the AWS console and ensuring a `.tfstate` file exists
Now `cd` back into your main project directory

## Running it straight away
Once you've initialised the remote state bucket and you've `cd`'d back into the main dir you should set your chosen s3 and dynamo table names in the `/s3-dynamo/variables.tf` file and `/root/backend.tf` file, then `terraform init`, `terraform plan` to check everything seems correct, then `terraform apply` to deploy the infrastructure.

## Creating a VPC
To create our VPC we can use the files within the VPC module. The `main.tf` includes the resource block, and a generic `CIDR range` for our VPC. It also includes a tag for the VPC itself, and a dynamic name so we can change this between environments. 
I've since refactored the `cidr_block` to be dynamic
I also specify some tags on this, so we can dynamically rename and state who's created this infra.
Within our outputs, so other portions of our terraform code have access, we 'return' `vpc_id` and `vpc_cidr_block`. This allows our other modules to access the newly created VPC_ID
Within the variables file we set our `CIDR block`, `ManagedBy` tag and `vpc_name` - these are all 'requested' within `/root/main.tf` and the values determined by our `.tfvars` file

## Creating our Subnets
First we find the available availability zones in the region using the `data` command. Then we check the length of the public CIDRs list we've set, and make that the count. We set the `vpc_id` to the created `vpc_id` (that's outputted). The `cidr_block` is then set to the index value of the subnet we're making (So the `public_cidrs` list has 3 elements, it will take the 1st element for 1st subnet, 2nd for 2nd and so on) and last it will take an availability zone from the pool of available ones, and again take the 1st zone for 1st subnet, and so on.
We output our public and private IDs using the wildcard (*), that 'returns' all the IDs.
Again with Variables we specify each that we want in the `main.tf` and `variables.tf`, these are then 'requested' within `/root/main.tf` and the values determined by our `.tfvars` file


## Creating an IGW
For the IGW we create a new resource in the igw folder, and output that so the route-tables can access the ID of the newly created internet gateway later. 
We just use our `vpc_id` here to ensure the IGW is associated to the correct VPC. 
To make sure we can attach things to this IGW, we also output the `gateway_id`. 
For variables, similar to above (except this isn't a `.tfvars` variable, just an output), we reference it in `main.tf` and `variables.tf` and this value is 'returned' from out `/vpc/outputs.tf`

## Creating a Route table
After creating our IGW we want to make sure that any public traffic is routed towards the IGW, so we create a new route table to do that. We use the outputted IGW ID to associate the new route table to, we also call this Public as this will deal with any web facing traffic.
Variables, similar to above, we grab the `internet_gateway_id` from `/igw/outputs.tf` and use that value (that's created on the fly)

## Creating a security group
To ensure we have ingress and egress for our service, we've set up 3 different security groups. One to allow http, one for https, and one for SSH. The http(s) versions allow traffic from anywhere, to anywhere. The SSH group only allows the users current IP address to SSH into the box, which allows cross team users to terraform apply themselves and be granted SSH access.
To ensure I've always got access to SSH when I spin this infra up, I've used a data function within Terraform and used that to grab my IP, then when setting the CIDR block for my SSH group, I use the response body from that `data` call as the value (and specifying `/32` to ensure only my specific IP can access this)

## Creating EC2 instances
Now we have our subnets and supporting infrastructure, time to make our EC2 instances. Initially to ensure we always have the most up to date AMI we use the `data` command of Terraform to find any Ubuntu images version 22.04 and select the newest with the `most_recent` flag.

We then get our relevant AZs again using the `data` command to create the subnets. 

When creating our EC2 instances we initially find out how many we need, determined by the number of public subnets (`count`). We then take the AMI data from the previous `data` call and use that as our image. 

For our AZs we loop through the available ones for each number of public subnets that exist and assign each one individually.

For the subnets the EC2 instance resides on we loop through our 'returned' `subnet_ids` from our subnet `outputs.tf` file and assign one EC2 instance into each existing subnet (Determined by the `count`). 

We also grab out security group IDs from the output of `sg` folder to assign to the EC2 instance. 

To make sure we have a public facing IPv4 I used the `associate_public_ip_address` attribute.

Finally I called the instance whatever the index of `count` is (which starts at 0, so we add one to that so we don't have `Instance 0`)

## nginx setup
Because we want our server to automatically work, so we don't need manual intervention, we can use a user-data file to trigger some scripts to run on start up. Within our EC2 modules, we add a key/value called 'user_data' that targets a script file. My script file is simply updating the `apt` packages, then installing `nginx` and then simply overwriting the contents of nginxs `html.index` to a message I decide. 

## Application Load Balancer, with Target Groups and Listener
To create our public facing load balancer we use the `aws_lb` resource, giving it the `subnets` and `security groups` we've included in our `variables.tf`. 

We need a `target group` to attach to, so create that using the `vpc_id` as the only required variable, we make sure it targets instances (EC2) and will accept requests from HTTP.  The group needs to be attached to the EC2 instances, so we use our newly created `target_group_arn` to determine which group to attach, and the `instance_ids` are the instances it will target (It will loop through these based on the `count`).

To ensure our load balancer functions correctly, we need a listener, so we created that assigning the newly created Load Balancers ARN to it, when the load balancer receives HTTP traffic, the listener will forward it to the appropriate target group. 

## Auto Scaling Group
Now we have our core infrastructure created, we want to ensure it's resilient to failure and can handle a surge of requests when needed. We use an autoscaling group for this. 

Initially we create a launch template for the autoscaling group, this is like an EC2 instance creation template, so we tell it the AMI, Instance Type and SSH key we want to use. We also feed it some `user-data` scripts, which ensures that nginx is installed on the server, and amends the index.html file as well.

To ensure the new boxes are 'visible' and able to be hit, we give it a network interface, automatically assigning a public IP address and also allowing ingress and egress via HTTP(S) and also ingress for only my IP address for SSH. Anyone who runs this Terraform code will be able to SSH into the new boxes.

Now for the autoscaler itself, to make sure it's not used when we don't want it I've used a ternary operator based on a flag I set in .tfvars (This would be possible to request each time terraform apply is run, but I want it to to default to true so I'm making it a manual amend). If the `use_auto_scaling_group` flag is 'true' then we don't spin up any EC2 instances using our EC2 module, instead we let the autoscaler do all the work. Conversely, if the flag is 'false' then the autoscaler doesn't get created, and instead we just have 3 EC2 instances that have no scaling ability.

We set some additional flags on this for desired capacity and min/max size etc, and assign it a `target_group_arns` list to determine what target group it associates the new instances with. Then we set the subnets, using the `vpc_zone_identifier` parameter and passing in our public subnets (output from the subnets module and called within `root/main.tf`) 

We then use the launch template I created higher in the `/asg/main.tf` file as the type of instance to create! 

# FIN.

Thanks for coming to my Terraform Ted Talk.