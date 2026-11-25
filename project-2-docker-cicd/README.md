# Project 2 — Automated Docker Deployment with AWS & GitHub Actions

## 1. Project Overview

I built an automated CI/CD pipeline to deploy a containerised Nginx website to **Amazon EC2**. I used **Terraform** to provision the AWS infrastructure, **GitHub Actions** to build and publish Docker images to **Amazon ECR**, and **AWS Systems Manager (SSM)** to deploy updates without SSH.

To verify the pipeline end to end, I changed `website.html`, pushed the change to GitHub and confirmed that the updated content appeared on the EC2-hosted website.

## 2. Technologies Used

| Technology | Purpose |
|---|---|
| **Terraform** | Provision and manage AWS infrastructure as code |
| **Amazon VPC** | Provide a public subnet, routing and internet connectivity |
| **Amazon EC2** | Host the Dockerised application on Amazon Linux 2023 |
| **Docker & Nginx** | Package and serve the HTML website |
| **Amazon ECR** | Store private Docker images |
| **GitHub Actions** | Automate image builds, pushes and deployments |
| **AWS IAM & OIDC** | Allow GitHub Actions to assume an AWS role without long-lived access keys |
| **AWS Systems Manager** | Run deployment commands on EC2 without SSH |

## 3. Architecture and CI/CD Pipeline


Developer
    |
    | Git Push
    v
GitHub Repository (main)
    |
    v
GitHub Actions
    |
    | OIDC Authentication
    v
AWS IAM Role
    |
    +---- Build Docker Image
    |
    +---- Push Image ---> Amazon ECR
    |
    +---- SSM Run Command
                           |
                           v
                     Amazon EC2
                           |
                           | Pull Image from ECR
                           v
                     Docker Container
                           |
                           v
                       Nginx
                           |
                           v
                    Website (HTTP 80)

**Deployment sequence:** A push to `main` triggers the workflow, which builds an image and pushes it to ECR. GitHub Actions then uses SSM to tell EC2 to authenticate with ECR, pull the latest image, replace the website container and check that the site responds over HTTP.

## 4. Project Implementation

**Infrastructure:** I used Terraform in `eu-west-2` (London) to create a VPC (`10.0.0.0/16`), public subnet (`10.0.0.0/24`), internet gateway, route table, security group, EC2 instance, IAM roles and ECR repository. I reviewed changes with `terraform plan` before applying them.

**Application:** I created a Dockerfile based on `nginx:alpine` and copied `website.html` into the Nginx web directory. I tested it locally before deploying it to AWS.

**Automation:** My GitHub Actions workflow authenticated with AWS using OIDC, built and pushed the Docker image, and sent SSM commands to EC2. The deployment replaced the previous website container and used a retrying HTTP health check to allow Nginx time to start.

## 5. Troubleshooting and Challenges

| Issue | Investigation and resolution |
|---|---|
| **ECR `403 Forbidden`** | The Docker push failed when accessing an image manifest. I updated the GitHub Actions IAM policy to include `ecr:BatchGetImage` and `ecr:GetDownloadUrlForLayer`. |
| **Docker authentication on EC2** | ECR login had been performed as `ssm-user`, while `sudo docker pull` used root's Docker credentials. I used `sudo docker login` and `sudo docker pull` consistently. |
| **Unexpected EC2 replacement** | Terraform proposed replacing EC2 after a user-data change. I reviewed the plan and used `ignore_changes` for `user_data` on this lab instance to avoid unintended replacement. |
| **Health-check failure** | SSM reported `curl: (56) Recv failure: Connection reset by peer`. I checked SSM output, confirmed the container was running and received HTTP 200 manually, then added retries to the health check. |
| **Git workflow issues** | I resolved diverged branches and restored an accidentally deleted workflow file from Git history, checking staged changes before pushing again. |

## 6. Security Considerations

- **OIDC authentication:** GitHub Actions assumed an IAM role instead of using long-lived AWS keys; the trust policy was restricted to the repository's `main` branch.
- **Restricted IAM access:** The workflow used permissions for the Project 2 ECR repository and SSM deployment actions.
- **No SSH exposure:** EC2 administration and deployment used Systems Manager, so inbound SSH port 22 was not required.
- **Network controls:** The EC2 security group allowed inbound HTTP traffic on port 80.
- **State and image hygiene:** Terraform state and sensitive configuration files were kept out of version control; ECR image scanning on push was enabled.

## 7. Testing and Results

- **Local Docker:** Served `website.html` through port mapping `8080:80` and received an HTTP 200 response.
- **ECR and SSM:** Confirmed that GitHub Actions pushed the image to ECR and EC2 pulled it using SSM.
- **End-to-end CI/CD:** Changed `website.html`, pushed to `main` and verified that the live EC2 website displayed the new content without manual redeployment.

The website response included:

```text
Project 2 - CI/CD Deployment Successful!
Version 2 - Automated Deployment Test
```

The final GitHub Actions deployment and HTTP health check completed successfully.

## 8. Cleanup and Conclusion

After testing, I used `terraform destroy` to remove the EC2 instance, networking and IAM resources. I also deleted the remaining non-empty ECR repository and its images, then confirmed Terraform had no resources left to destroy.

**Outcome:** I successfully built and tested an automated Docker deployment pipeline using Terraform, GitHub Actions, ECR, SSM and EC2. This project strengthened my practical skills in infrastructure automation, IAM permissions, deployment troubleshooting and CI/CD.

> **Note:** The lab infrastructure has been destroyed to avoid ongoing AWS costs. The previously deployed website URL is no longer active.
