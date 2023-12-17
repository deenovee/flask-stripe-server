Flask Server on AWS EC2
This repository contains a simple Python Flask server that utilizes the Stripe API for handling product information and creating checkout sessions. The server is designed to be hosted on an AWS EC2 instance. Below are instructions for deploying and setting up the server.

Prerequisites
AWS account with appropriate permissions to create EC2 instances and security groups.
Stripe API key (replace 'sk_......' with your actual Stripe secret key).

Deployment

1. EC2 Instance Setup:

Use the provided CloudFormation template (cloudformation-template.yaml) to create the necessary AWS resources. This includes an EC2 instance, a security group allowing SSH (port 22) and HTTP (port 80) traffic, and an optional key pair for SSH access.

    ```bash
    aws cloudformation create-stack --stack-name YourStackName --template-body file://cloudformation-template.yaml --parameters ParameterKey=SshIp,ParameterValue=0.0.0.0/0 ParameterKey=ImageId,ParameterValue=ami-0b898040803850657 ParameterKey=InstanceType,ParameterValue=t2.micro

2. Clone the Repository:
    ```bash
    git clone https://github.com/yourusername/flask-stripe-ec2.git
    cd flask-stripe-ec2

3. Install Dependencies:
    ```bash
    pip install -r requirements.txt

4. Configure Stripe API Key:
    Replace 'sk_......' in app.py with your actual Stripe secret key.

    stripe.api_key = 'your_stripe_secret_key'

5. Run the Flask Server:
    ```bash
    python3 app.py

Usage

Access the products endpoint: http://your-ec2-instance-ip:5000/
Create a checkout session: Send a POST request to http://your-ec2-instance-ip:5000/create-checkout-session with a JSON payload containing line items.

Cleanup
To delete the resources created by the CloudFormation stack:

    ```bash
    aws cloudformation delete-stack --stack-name YourStackName

Additional Notes
Ensure your security group allows traffic on port 80 for HTTP access. Uncomment the corresponding lines in the CloudFormation template if you want to enable HTTPS.
Customize the success and cancel URLs in app.py to match your application's flow.
Make sure to secure your EC2 instance properly, and consider using a web server (e.g., Nginx) in production for better performance and security.

