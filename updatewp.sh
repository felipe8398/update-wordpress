#!/bin/bash

#########################################################################
# 									#
# updatewp.sh - Atualizando o Wordpress de forma automatica		#
#									#
# Autor: Felipe Silveira (felipe.silveira@outlook.com)			#
# Data Criação: 16/10/1997						#
#									#
# Descrição: Criando uma rotina de atualização do Wordpress.		#
#									#
# Exemplo de uso: bash updatewp.sh					#
#									#
#########################################################################

##################### Variaveis ########################################
# Log da movimentação
LOG=/var/log/updatewp.log
PastaWP=/var/www
DownloadWP=$PastaWP/
########################################################################




# Iniciando o log da atualização
echo "Iniciando a atualização do Wordpress em $(date)" >> $LOG

# Verificando a versão do wordpress e jogando para o log #
VERSAO=$(cat /var/www/wordpress/wp-includes/version.php | grep wp_version | tail -n1 | awk -F "= '" '{print $2}' | awk -F "'" '{print $1}')
echo  "Versão do Wordpress é: $VERSAO" >> $LOG

# Removendo a versão antiga baixada #
echo "Removendo o tar.gz da penultima versao do Wordpress" >> $LOG
rm $PastaWP/latest.tar.gz 2>> $LOG

# Download  da ultima versão do Wordpress #
echo "Realizando o download do Wordpress novo" >> $LOG
cd $DownloadWP && wget https://wordpress.org/latest.tar.gz >> $LOG

# Guardando a penultima versão #
echo "Guardando a penultima versão do Wordpress" >> $LOG
mv $PastaWP/wordpress/ $PastaWP/wordpress_$VERSAO/ >> $LOG 2>&1

# Extraindo a versão que foi feita o download #
echo "Extraindo a nova versão" >> $LOG
tar -zxvf $PastaWP/latest.tar.gz >> $LOG 2>&1

# Copaindo o wp-content, .htaccess e wp-config da versão antiga para a nova # 
echo "Copiando o WP-CONTENT da versão antiga para a nova" >> $LOG
cp -r $PastaWP/wordpress_$VERSAO/wp-content/ $PastaWP/wordpress >> $LOG 2>&1
echo "Copiando o WP-CONFIG da versão antiga para a nova" >> $LOG
cp $PastaWP/wordpress_$VERSAO/wp-config.php $PastaWP/wordpress >> $LOG 2>&1
echo "Copiando o .HTACCESS da versão antiga para a nova" >> $LOG
cp $PastaWP/wordpress_$VERSAO/.htaccess $PastaWP/wordpress >> $LOG 2>&1

# Reiniciando o apache #
echo "Reiniciando o Apache" >> $LOG
/etc/init.d/apache2 restart >> $LOG 2>&1
