
#-------------------------------------
# Creating SSH Key Pair
# ------------------------------------
# 1)Commands to generate keys in the file key_wordpress/ key_wordpress.pub
#  ssh-keygen -t rsa -b 4096
#  Save in the Pub and Priv Keys in ./key_wordpres
#  Convert Priv key to ppk :   puttygen key_wordpress  -O private  -o key_wordpress.ppk
# 

resource "aws_key_pair" "key_wordpress" {
  key_name   =   "key_wordpress"
  public_key =   "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCchfKKtbc9k4YcyHHX2PEkt10G4HlYQ0FkdkUBIUlTijXktdoVTfVEPZJLXiN5tboxS4LjUD2NaLbp0L3z8MjlyhqF4YD+Lui+gG8M6lKLrqbjguPePM39wcmFmGu2S/yQTfKLlMrpKszeBwxcDh1tE1ZXHxxphWurhqXp5Kfq1BrdE6gmWl49AfV9mixVHparlGXvDf8Sz1qAKSv0SuMDxTbMfxLUCakIO+u6b6z0sT7Gpp+G3Yv6T0lp0D48oXHwNpQaikyFa07T2RnHCkf67IdiCuhxfekEpzX3d7zb2xY6Hf+H2ZSLbujOQqa5TbxxAHCyXOEpPvBXS+UIa8qUYb796UWOyxVSyf1c20ItrExq/+rSVvhenQLfr6db5C7IQUU4VdfhlTbmAZ0Xue6zY7iMGX3ZaOc1fj4hRQT9E3cjmd50qKXpTVddIimTPXMTqEPTJKxdugdFNBy74nZUqn6ZNtdFeH6xCChJdHcoIIL3S71SLy5fqwWff1C4C05VzYOWoRpE6+vYXBSStBkkYTWa4y5CdkFNR5RYOGphckc3TZGcsZTEUokZKigHCOZSJxeB2nBoYiIwb8a9fRry3AIgPdV6f3tPWG0e0DrAExZxEB1R2iT6c3Vk0JqMgAej76LObJFmeCho8V34aHninClpoovi03i94eFAGT9lYw== lcfrod@lcfrod-IdeaPad"
#  public_key =  file("key_wordpress.pub")
  tags = {
      Name  = "WordPress Key Pair"
  }
}
