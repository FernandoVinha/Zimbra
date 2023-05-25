#!/bin/bash

# Atualize o sistema
sudo apt-get update
sudo apt-get upgrade -y

# Instale e configure o UFW
sudo apt-get install ufw
sudo ufw allow 22
sudo ufw allow 25
sudo ufw allow 80
sudo ufw allow 110
sudo ufw allow 143
sudo ufw allow 443
sudo ufw allow 465
sudo ufw allow 587
sudo ufw allow 993
sudo ufw allow 995
sudo ufw allow 7071
sudo ufw enable

# Defina o nome do host
sudo hostnamectl set-hostname mail.bitcoin-card.org


# Baixe o Zimbra
wget https://files.zimbra.com/downloads/8.8.15_GA/zcs-8.8.15_GA_3869.UBUNTU16_64.20190917004220.tgz

# Descompacte o arquivo Zimbra
tar xvf zcs-8.8.15_GA_3869.UBUNTU16_64.20190917004220.tgz

# Navegue até o diretório e instale o Zimbra
cd zcs-8.8.15_GA_3869.UBUNTU16_64.20190917004220
sudo ./install.sh

# Instale o certbot
sudo apt-get install software-properties-common
sudo add-apt-repository universe
sudo add-apt-repository ppa:certbot/certbot
sudo apt-get update
sudo apt-get install certbot

# Pare os serviços Zimbra
sudo -u zimbra zmcontrol stop

# Emita o certificado
sudo certbot certonly --standalone --preferred-challenges http -d mail.bitcoin-card.org

bitcoin-card.org
# Instale o certificado no Zimbra
sudo -u zimbra zmcertmgr verifycrt comm /etc/letsencrypt/live/mail.bitcoin-card.org/privkey.pem /etc/letsencrypt/live/mail.bitcoin-card.org/cert.pem /etc/letsencrypt/live/mail.bitcoin-card.org/chain.pem
sudo cp /etc/letsencrypt/live/mail.bitcoin-card.org/privkey.pem /opt/zimbra/ssl/zimbra/commercial/commercial.key
sudo chown zimbra:zimbra /opt/zimbra/ssl/zimbra/commercial/commercial.key
sudo -u zimbra zmcertmgr deploycrt comm /etc/letsencrypt/live/mail.bitcoin-card.org/cert.pem /etc/letsencrypt/live/mail.bitcoin-card.org/chain.pem

# Inicie os serviços Zimbra
sudo -u zimbra zmcontrol start
