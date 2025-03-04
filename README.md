# Terraform Infrastructure Projects

This repository contains a collection of Infrastructure as Code (IaC) projects using Terraform to deploy various AWS services. Each project is designed to be self-contained and follows infrastructure best practices.

## Projects

### 1. LAMP Stack Infrastructure (`lamp-stack-infra/`)

A modern LAMP (Linux, Apache, MySQL, PHP) stack deployment using containerized services:
- Frontend and Backend containers running on ECS Fargate
- RDS MySQL database with proxy for connection management
- Application Load Balancer for traffic routing
- Comprehensive networking with public/private subnets

[View LAMP Stack Details](lamp-stack-infra/README.md)

### 2. Jenkins Server (`jenkins-server/`)

Automated deployment of a Jenkins CI/CD server:
- EC2 instance with Jenkins pre-installed
- VPC with public subnet for accessibility
- Security groups for controlled access
- Automated installation via user data script

[View Jenkins Server Details](jenkins-server/README.md)

## Repository Structure

```
terraform_projects/
├── lamp-stack-infra/     # LAMP Stack with containerized services
│   ├── alb.tf           # Application Load Balancer configuration
│   ├── ecs.tf           # ECS Fargate services and task definitions
│   ├── rds.tf           # RDS MySQL and proxy setup
│   └── README.md        # Detailed project documentation
│
├── jenkins-server/      # Jenkins CI/CD server setup
│   ├── main.tf          # Core infrastructure configuration
│   ├── variables.tf     # Input variables
│   └── README.md        # Project documentation
│
└── README.md           # This file
```

## Common Features

- **Infrastructure as Code**: All infrastructure defined and versioned in code
- **Modular Design**: Each project is self-contained and reusable
- **Security Best Practices**: Proper network isolation and access controls
- **Documentation**: Comprehensive READMEs with setup instructions

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform v1.0.0 or later
- Basic understanding of AWS services
- Git for version control

## Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/godcandidate/terraform_projects.git
   cd terraform_projects
   ```

2. Choose a project directory:
   ```bash
   cd <project-name>
   ```

3. Follow the project-specific README for detailed setup instructions.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
