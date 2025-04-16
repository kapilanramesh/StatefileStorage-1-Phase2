---

# ✅ **Terraform + Ansible Project: Provisioning Web Server on AWS**

## 🧾 **Overview**

This project automates the provisioning of a web server on AWS using Terraform and Ansible. It follows infrastructure as code (IaC) best practices by:

- Creating an EC2 instance using Terraform.
- Using Ansible to configure the instance as a NGINX web server.
- Using remote backend (S3 + DynamoDB) for Terraform state management.

---

## 📂 **Project Structure**

| File                | Description |
|---------------------|-------------|
| `main.tf`           | Creates AWS infrastructure (EC2 instance, security group). |
| `variable.tf`       | Declares input variables like region, AMI, instance type, key name, etc. |
| `terraform.tfvars`  | Provides actual values for the declared variables. |
| `outputs.tf`        | Outputs the EC2 instance public IP address. |
| `ansible.cfg`       | Configures Ansible to use `hosts.ini` inventory file. |
| `hosts.ini`         | Inventory file with target EC2 instance IP. |
| `playbook.yml`      | Ansible playbook to install and start NGINX. |

---

## ⚙️ **Terraform: Infrastructure Provisioning**

Absolutely Kapilan! Here's a **detailed, line-by-line explanation** of the `main.tf` file in your project, written in a super beginner-friendly and crystal-clear way:

---

## 🔍 `main.tf` 

> This file is responsible for **creating the EC2 instance** and **setting up the security group** so that you can access it via SSH and HTTP.

---

### ✅ 1. **Provider Block**

```hcl
provider "aws" {
  region = var.aws_region
}
```

- This tells Terraform to use **AWS** as the cloud provider.
- The `region` is taken from a variable (`aws_region`) that you define in `terraform.tfvars`.

---

### ✅ 2. **Security Group for EC2**

```hcl
resource "aws_security_group" "web_sg" {
  name        = "web-server-sg"
  description = "Allow HTTP and SSH"
```

- This block **creates a security group** (a virtual firewall) that allows only **port 22 (SSH)** and **port 80 (HTTP)** traffic.
- The name is `web-server-sg`.

```hcl
  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
```

- Allows **SSH access** to the instance (port 22).
- `cidr_blocks = ["0.0.0.0/0"]` means **anyone can connect via SSH** (this is fine for testing, but for production, restrict IPs).

```hcl
  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
```

- Allows **HTTP access** so a browser can load your website (NGINX later).
- Port 80 is used for regular websites.

```hcl
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
```

- This allows **all outbound traffic** (e.g., downloading updates or software from the internet).

```hcl
  tags = {
    Name = "web-sg"
  }
}
```

- Tags the security group with a name (for easy identification in AWS console).

---

### ✅ 3. **EC2 Instance**

```hcl
resource "aws_instance" "web" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.web_sg.id]
```

- This block **creates an EC2 virtual machine**.
- `ami`: Defines the operating system (you provide an Ubuntu AMI).
- `instance_type`: Defines hardware (e.g., `t2.micro` = free tier).
- `key_name`: The SSH key you'll use to login to the instance.
- `vpc_security_group_ids`: Assigns the security group we just created.

```hcl
  associate_public_ip_address = true
```

- Gives the instance a **public IP**, so it’s accessible from the internet.

```hcl
  tags = {
    Name = "web-server"
  }
}
```

- Tags the EC2 instance with a name (`web-server`) for easy identification in AWS.

---

## 🔚 Summary (What This File Does):

✅ **Creates** a security group that:
- Allows SSH (22)
- Allows HTTP (80)
- Allows all outbound traffic

✅ **Launches** an EC2 instance that:
- Runs Ubuntu (via `ami`)
- Is accessible with your SSH key
- Is publicly reachable
- Is tagged for clarity
  
---

### 🔹 `variable.tf` – Declares Required Variables

```hcl
variable "aws_region" {}
variable "ami" {}
variable "instance_type" {}
variable "key_name" {}
```

---

### 🔹 `terraform.tfvars` – Variable Values

```hcl
aws_region     = "ap-south-1"
ami            = "ami-0c55b159cbfafe1f0"   # Example Ubuntu AMI in Mumbai
instance_type  = "t2.micro"
key_name       = "kapilan-key"            # Replace with your actual key
```

> 💡 Make sure `kapilan-key.pem` exists in your `~/.ssh` folder and matches the key in `terraform.tfvars`.

---

### 🔹 `outputs.tf` – Exposes the Public IP

```hcl
output "instance_public_ip" {
  value = aws_instance.web.public_ip
}
```

After applying, this gives you the EC2 IP to SSH and configure with Ansible.

---

## 🔧 **Ansible: Web Server Configuration**

### 🔹 `ansible.cfg`

```ini
[defaults]
inventory = hosts.ini
host_key_checking = False
```

Sets Ansible to use `hosts.ini` and disables host key verification.

---

### 🔹 `hosts.ini`

```ini
[web]
65.0.6.230 ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa
```

Specifies:
- EC2 public IP
- SSH username (for Ubuntu AMIs it's always `ubuntu`)
- Path to SSH private key

---

### 🔹 `playbook.yml` – Provision Web Server

```yaml
- name: Provision web server
  hosts: web
  become: yes

  tasks:
    - name: Update apt cache
      apt:
        update_cache: yes

    - name: Install NGINX
      apt:
        name: nginx
        state: present

    - name: Start and enable NGINX
      systemd:
        name: nginx
        state: started
        enabled: yes
```

**Steps Performed:**
1. Updates Ubuntu package cache
2. Installs NGINX
3. Ensures NGINX is running and enabled on startup

---

## 🚀 **How to Run the Project**

### 1️⃣ Terraform – Infrastructure
```bash
terraform init
terraform plan
terraform apply
```

Once done, copy the **public IP** from output and update it in `hosts.ini`.

### 2️⃣ Ansible – Web Server Setup
```bash
ansible-playbook playbook.yml
```

Visit: `http://<your-ec2-ip>` — You should see the **NGINX welcome page**!

---
