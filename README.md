Thanks for uploading all **five scripts** from the **second repository**. Here's a breakdown of what you've shared:

1. `main.tf`
2. `variable.tf`
3. `terraform.tfvars`
4. `outputs.tf`
5. `playbook.yml`

---

### 📘 README – **Terraform + Ansible Automation for Provisioning a Web Server**

---

#### 📌 **Project Overview**

This repository combines **Terraform** and **Ansible** to automatically provision a cloud infrastructure and configure it with a simple web server (NGINX).  

- **Terraform** handles the infrastructure provisioning (e.g., creating EC2 instances on AWS).
- **Ansible** configures the provisioned server by installing and managing NGINX.

---

### 🧱 File-by-File Breakdown

---

#### `main.tf`  
> **Terraform infrastructure definition file**

- **Provider Setup**: Connects to AWS using credentials (region defined in `terraform.tfvars`).
- **EC2 Instance Creation**:
  - Launches an instance using the provided AMI ID and instance type.
  - Connects the instance to a security group allowing inbound traffic on HTTP (port 80) and SSH (port 22).
  - Uses a key pair for secure access (key name specified in `terraform.tfvars`).
  - Tags the instance (for identification).
- **Provisioner Block**:
  - May include `remote-exec` or similar blocks (not visible here) to bootstrap or prepare for Ansible.

---

#### `variable.tf`  
> **Variable declarations for Terraform**

- Declares variables such as:
  - `access_key` and `secret_key` for AWS authentication.
  - `region`, `instance_type`, `ami_id`, `key_name`, and `my_ip` (used for creating security rules).
- Ensures all inputs are flexible and maintainable by defining them externally.

---

#### `terraform.tfvars`  
> **Values for declared variables**

Example (actual values may differ):
```hcl
access_key     = "AKIA..."
secret_key     = "SECRET..."
region         = "us-east-1"
instance_type  = "t2.micro"
ami_id         = "ami-0abcdef1234567890"
key_name       = "my-key"
my_ip          = "123.123.123.123/32"
```

You can modify this file to adapt the infrastructure for any AWS region or key.

---

#### `outputs.tf`  
> **Terraform output declarations**

- Displays key outputs after running `terraform apply`, such as:
  - The public IP address of the EC2 instance.
  - Instance ID or DNS.
- Useful for passing dynamic information to Ansible or for manual inspection.

---

#### `playbook.yml`  
> **Ansible Playbook to configure the EC2 instance**

- **Target Host**: Assumes inventory has a host group named `web`.
- **Tasks**:
  1. **Update apt cache** – Refresh package index.
  2. **Install NGINX** – Deploys the web server.
  3. **Start and enable NGINX** – Ensures the server runs and starts on boot.

This playbook assumes passwordless SSH (likely via the key used in Terraform) and that Python is installed on the target.

---

### 🚀 How to Use This Repository

#### 1. **Set Up AWS Credentials**
Make sure your AWS access and secret keys are valid. NEVER hardcode them in the script—keep them inside `terraform.tfvars`.

#### 2. **Initialize Terraform**
```bash
terraform init
```

#### 3. **Validate & Apply Plan**
```bash
terraform plan
terraform apply
```
You’ll see the EC2 instance created, and its IP output at the end.

#### 4. **Configure Inventory for Ansible**
Create a file called `inventory.ini` like:
```ini
[web]
<EC2_PUBLIC_IP> ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/my-key.pem
```

#### 5. **Run Ansible Playbook**
```bash
ansible-playbook -i inventory.ini playbook.yml
```

#### 6. **Test**
Go to `http://<EC2_PUBLIC_IP>` in your browser — you should see the NGINX welcome page 🌐

---

### 🔐 Security Notes

- The security group opens HTTP (80) and SSH (22) only to your IP (defined via `my_ip`).
- Never commit real credentials or `.pem` files to version control!

---

### 📦 Requirements

- [Terraform](https://developer.hashicorp.com/terraform/downloads)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
- AWS CLI & valid credentials
- SSH key pair (configured in AWS and on your local machine)

---

### 🧹 Clean Up

To destroy all provisioned resources:
```bash
terraform destroy
```

---


