provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "mi_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet_publica" {
  vpc_id = aws_vpc.mi_vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet_privada" {
  vpc_id = aws_vpc.mi_vpc.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = false
}


#Creamos el grupo de seguridad para el servidor web 
resource "aws_security_group" "sg_servidorweb" {
    vpc_id = aws_vpc.mi_vpc.id

    #Permitir acceso HTTP desde cualquier parte (para la web)
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    #Permitimos acceso HTTPS de manera segura desde cualquier parte (para la web)
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    #Permitimos acceso desde nuestra IP para SSH
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["92.59.51.182/32"]
    }


    }


#CREAMOS EL GRUPO DE SEGURIDAD PARA EL BACKEND
resource "aws_security_group" "sg_backend" {
  vpc_id = aws_vpc.mi_vpc.id

#Permitir el trafico sólo desde el servidor WEB
  ingress {
    from_port = 5000
    to_port = 5000
    protocol = "tcp"
    security_groups = [ aws_security_group.sg_servidorweb.id ] #Solo el servidor web puede acceder
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}


#CREAMOS EL GRUPO DE SEGURIDAD PARA LA BASE DE DATOS
resource "aws_security_group" "sg_base_datos" {
  vpc_id = aws_vpc.mi_vpc.id

  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    security_groups = [ aws_security_group.sg_backend.id ] # Solo el backend puede acceder
  }
}


# CREAMOS LAS INSTANCIAS
# INSTANCIA PARA EL SERVIDOR WEB 

resource "aws_instance" "mi_servidor_web" {
    ami = "ami-053a45fff0a704a47"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.subnet_publica.id
    associate_public_ip_address = true
    vpc_security_group_ids = [ aws_security_group.sg_servidorweb.id ] #Le asignamos a la instancia el grupo de seguridad 

    tags = {
      Name = "Servidor Web"
    }
  
}


#Crear la instancia para el backend
resource "aws_instance" "mi_backend" {
  ami = "ami-053a45fff0a704a47"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.subnet_publica.id
  associate_public_ip_address = false
  vpc_security_group_ids = [ aws_security_group.sg_backend.id ] #Le asignamos el grupo de seguridad

  tags = {
    Name = "Backend"
  }
}


#Crear la instancia para la base de datos
resource "aws_instance" "base_datos" {
    ami = "ami-053a45fff0a704a47"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.subnet_privada.id
    associate_public_ip_address = false
    vpc_security_group_ids = [ aws_security_group.sg_base_datos.id ]

    tags = {
      Name = "MiBaseDatos"
    }
  
}
