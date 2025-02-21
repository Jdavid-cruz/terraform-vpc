Este repositorio contiene la configuración de una infraestructura en AWS utilizando Terraform.
Descripción del proyecto

Este proyecto configura una infraestructura básica en AWS utilizando Terraform. Se ha diseñado para desplegar una aplicación web con una arquitectura separada en tres capas:

    Servidor web
    Backend
    Base de datos

Se han definido los recursos necesarios para crear una red privada virtual (VPC), subredes, grupos de seguridad y las instancias EC2 correspondientes.
Infraestructura creada
1. VPC y Subredes

    Se ha creado una VPC con el rango 10.0.0.0/16 para alojar toda la infraestructura.
    Se han definido dos subredes dentro de la VPC:
        Subred pública (10.0.1.0/24), donde se ubican el servidor web y el backend.
        Subred privada (10.0.2.0/24), donde se aloja la base de datos.

2. Grupos de Seguridad

Para controlar el tráfico de red entre las instancias, se han configurado tres grupos de seguridad:

    Grupo de seguridad del Servidor Web
        Permite tráfico HTTP (80) y HTTPS (443) desde cualquier origen.
        Permite acceso SSH (22) únicamente desde la dirección IP del administrador.

    Grupo de seguridad del Backend
        Permite tráfico en el puerto 5000 solo desde el servidor web.
        Permite salida a Internet para descargas y actualizaciones.

    Grupo de seguridad de la Base de Datos
        Permite conexiones en el puerto 5432 solo desde el backend.
        No tiene acceso público.

3. Instancias EC2

Se han creado tres instancias EC2, cada una con una función específica dentro de la arquitectura:

    Servidor Web
        Ubicado en la subred pública con una IP pública asignada.
        Protegido por el grupo de seguridad del servidor web.

    Backend
        Ubicado en la subred pública, pero sin IP pública.
        Accesible solo desde el servidor web.
        Protegido por el grupo de seguridad del backend.

    Base de Datos
        Ubicada en la subred privada sin acceso a Internet.
        Solo permite conexiones desde el backend.
        Protegida por el grupo de seguridad de la base de datos.

Implementación

Para desplegar esta infraestructura en AWS, sigue los siguientes pasos:

    Clonar este repositorio:

git clone https://github.com/Jdavid-cruz/terraform-vpc.git
cd terraform-vpc

Inicializar Terraform:

terraform init

Planear la infraestructura:

terraform plan

Aplicar la configuración:

    terraform apply -auto-approve

Consideraciones

Esta es una configuración básica de infraestructura en AWS con Terraform. Se puede mejorar añadiendo funcionalidades como:

    Balanceador de carga para el servidor web.
    Uso de RDS en lugar de una instancia EC2 para la base de datos.
    Auto Scaling Groups para el backend y el servidor web.

Este repositorio está disponible para ser modificado y adaptado según las necesidades del proyecto.
