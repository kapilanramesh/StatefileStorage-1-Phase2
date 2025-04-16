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

### 🔹 `main.tf` – Resources Defined

Creates:
- **EC2 Instance** with:
  - `ubuntu` AMI
  - SSH key access
  - Security group allowing HTTP (port 80) and SSH (port 22)

- **Security Group**:
  - Ingress rules for SSH and HTTP
  - Egress for all outbound traffic

---

### 🔹 `variable.tf` – Declares Required Variables

```hcl
variable "aws_region" {}
variable "ami" {}
variable "instance_type" {}
variable "key_name" {}
```

---

### 🔹 `terraform.tfvars` – Your Variable Values (You asked me to generate this)

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

## 🔐 **Security Tips**
- Security group restricts ports to HTTP and SSH only.
- Never expose your private key or hardcode it in public repos.
- Use `prevent_destroy` for important resources in Terraform (like in the backend setup you previously shared).

---

## 🧠 **Extra Notes**
- You can combine this setup with the earlier **Terraform Backend** project (S3 + DynamoDB) to store Terraform state remotely.
- You can add more roles to Ansible (e.g., deploying your own app).

---

If you'd like this as a `README.md` file to include in your repo, I can generate that for you too. Just say the word!
