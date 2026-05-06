# image-processor
# Instrucciones del proyecto

Este proyecto utiliza Terraform para desplegar infraestructura en AWS.

## Requisitos previos

Antes de comenzar, asegúrate de tener instalado Terraform, AWS CLI y acceso a AWS mediante SSO.

## Instalación de Terraform

Ejecuta los siguientes comandos para instalar Terraform:

sudo apt-get update
sudo apt-get install -y gnupg software-properties-common curl

curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update
sudo apt install terraform -y


##Instalación de AWS CLI

Instala AWS CLI con:

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

unzip awscliv2.zip

sudo ./aws/install

##Configuración de AWS SSO

aws configure sso

export AWS_PROFILE=dev-sso

#Ejecución del proyecto

Inicializa Terraform:

terraform init

Creación de entornos:

terraform workspace new dev

terraform workspace new qa

terraform workspace new prod

Revisa los cambios:

terraform plan

Aplica la infraestructura:

terraform apply