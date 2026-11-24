# Multi-AZ 3-Tier Web Application Architecture on AWS

A fault-tolerant, scalable 3-tier web architecture built on AWS across two Availability Zones (`ap-southeast-2`), designed for high availability and layered network security.

## Architecture Overview


## Architecture Overview

[ Internet Users ]
│
▼ (HTTP: 80)
[ Application Load Balancer (ALB) ] <-- ALB-SG (0.0.0.0/0)
│
▼ (HTTP: 80)
[ Auto Scaling Group (EC2 Web Tier) ] <-- Web-EC2-SG (Source: ALB-SG only)
├── Availability Zone A (Public Subnet)
└── Availability Zone B (Public Subnet)
│
▼ (MySQL: 3306)
[ Amazon RDS MySQL (Database Tier) ] <-- DB-RDS-SG (Source: Web-EC2-SG only)
└── Isolated Private Subnets (Multi-AZ DB Subnet Group)

## Key Components Implemented
* **Custom Multi-AZ VPC (`10.0.0.0/16`):** Configured separate Public and Private Subnets across two Availability Zones with an Internet Gateway and custom Route Tables.
* **Defense-in-Depth Security (Security Group Chaining):**
  * `ALB-SG`: Accepts public HTTP (Port 80) traffic.
  * `Web-EC2-SG`: Accepts HTTP traffic *only* from `ALB-SG`, preventing direct public access to EC2 instances.
  * `DB-RDS-SG`: Accepts MySQL (Port 3306) traffic *only* from `Web-EC2-SG`.
* **Load Balancing & Auto Scaling:** Configured an Internet-facing Application Load Balancer and Auto Scaling Group using an Amazon Linux 2023 Launch Template (`userdata.sh`) for automatic traffic distribution and instance self-healing.
* **Isolated Database Layer:** Deployed an Amazon RDS MySQL instance inside private subnets with public access disabled.

## Verification & Troubleshooting Highlights
* Verified cross-AZ load distribution by refreshing the ALB DNS endpoint and observing traffic alternate between `ap-southeast-2a` and `ap-southeast-2b`.
* Tested self-healing recovery by terminating an active EC2 instance and monitoring Auto Scaling Group activity logs and health check grace periods.
