# ------------------------------
#        Internet Gateway
# ------------------------------
resource "aws_internet_gateway" "igw_wordpress" {  # igw_wordpress É O NOME DO RECURSO PARA INTERNET GATEWAY QUE VAMOS UTILIZAR PARA DEIXAR NOSSA REDE EXTERNA PUBLICA PARA A INTERNET
  vpc_id = aws_vpc.vpc_wordpress.id               # AQUI VOCÊ DEFINE A QUAL VPC ESSA SUBREDE SERÁ ASSOCIADA. COLOQUE O NOME DA SUA VPC PRINCIPAL, NO MEU CASO, VPC_PROD.

  tags = {
    Name = "IGW WordPress"                         # AQUI VOCÊ DEFINE A TAG NAME QUE UTILIZARÁ NO RECURSO.
  }
}
