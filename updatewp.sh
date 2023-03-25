#!/bin/bash

#########################################################################
# Versao 0.1                                                                                    
#                                                                                               
# updatewp.sh - Atualizando o Wordpress de forma automatica                     
#                                                                               
# Autor: Felipe Silveira (felipe.silveira@outlook.com)                          
# Data Criação: 11/03/2023                                                      
#                                                                               
# Descrição: Criando uma rotina de atualização do Wordpress.            
#                                                                       
# Exemplo de uso: bash updatewp.sh                                      
#                                                                       
#########################################################################

##################### Variaveis do Sistema ##############################
# Logs da movimentação
LOG=/var/log/updatewp.log

# Variaveis do Wordpress
PastaWP=/var/www
DownloadWP=$PastaWP/

# Variavel do local dos plugins do Wordpress
Plugins=/var/www/wordpress/wp-content/plugins/
Themes=/var/www/wordpress/wp-content/themes/

###########################################################################

##################### Variaveis de Plugin #################################

###### Akismet ######

# Ver a versão mais nova do plugin do Akismet
VersaoAkismet=$(curl -s https://br.wordpress.org/plugins/akismet/ | grep \"downloadUrl\": | awk -F "plugin" '{print $2}' | awk -F '"' '{print $1}') 2> /dev/null

# Pega o nome do arquivo ZIP com a /
AkismetZip=$(echo "$VersaoAkismet" | awk -F "/" '{print $2}') 2> /dev/null

# Pega o nome do arquivo ZIP sem a /
Akismet=$(echo $VersaoAkismet | awk -F "/" '{print $2}') 2> /dev/null


###### Google site Kit ######

# Ver a versão mais nova do plugin do Google site Kit
VersaoGoogleKit=$(curl -s https://br.wordpress.org/plugins/google-site-kit/ | grep \"downloadUrl\": | awk -F "plugin" '{print $2}' | awk -F '"' '{print $1}') 2> /dev/null

# Pega o nome do arquivo ZIP com a /
GoogleKitZip=$(echo "$VersaoGoogleKit" | awk -F "/" '{print $2}') 2> /dev/null

# Pega o nome do arquivo ZIP sem a /
GoogleKit=$(echo $VersaoGoogleKit | awk -F "/" '{print $2}') 2> /dev/null

##################### Variaveis de Tema #####################################

###### Twenty Twenty-One ######

# Ver a versão mais nova do tema Twenty Twenty-One
VersaoTwentyOne=$(curl -s https://br.wordpress.org/themes/twentytwentyone/ | grep \"downloadUrl\": | awk -F "theme" '{print $2}' | awk -F '"' '{print $1}') 2> /dev/null

# Pega o nome do arquivo ZIP com a /
TwentyOneZip=$(echo "$VersaoTwentyOne" | awk -F "/" '{print $2}') 2> /dev/null

# Pega o nome do arquivo ZIP sem a /
TwentyOne=$(echo $VersaoTwentyOne | awk -F "/" '{print $2}') 2> /dev/null

###### Daily Blog ######

# Ver a versão mais nova do tema Daily Blog
VersaoDailyBlog=$(curl -s https://br.wordpress.org/themes/daily-blog/ | grep \"downloadUrl\": | awk -F "theme" '{print $2}' | awk -F '"' '{print $1}') 2> /dev/null

# Pega o nome do arquivo ZIP com a /
DailyBlogZip=$(echo "$VersaoDailyBlog" | awk -F "/" '{print $2}') 2> /dev/null

# Pega o nome do arquivo ZIP sem a /
DailyBlog=$(echo $VersaoDailyBlog | awk -F "/" '{print $2}') 2> /dev/null

###########################################################################

# Iniciando o log da atualização #
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

# Copiando o wp-content, .htaccess e wp-config da versão antiga para a nova #
echo "Copiando o WP-CONTENT da versão antiga para a nova" >> $LOG
cp -r $PastaWP/wordpress_$VERSAO/wp-content/ $PastaWP/wordpress >> $LOG 2>&1
echo "Copiando o WP-CONFIG da versão antiga para a nova" >> $LOG
cp $PastaWP/wordpress_$VERSAO/wp-config.php $PastaWP/wordpress >> $LOG 2>&1
echo "Copiando o .HTACCESS da versão antiga para a nova" >> $LOG
cp $PastaWP/wordpress_$VERSAO/.htaccess $PastaWP/wordpress >> $LOG 2>&1

# Atualizando os Plugins #

# Apaga a versão antiga do Plugin Akismet #
echo "Apagando a versão antiga do Akismet" >> $LOG
rm -rf $Plugins/akismet/ >> $LOG 2>&1

# Faz o download da versão mais atual do plugin Akismet #
echo "Download da versão mais atual do Akismet" >> $LOG
cd $Plugins && wget https://downloads.wordpress.org/plugin/$VersaoAkismet >> $LOG 2>&1

# Retira o zip do Akismet e exclui o arquivo .zip #
unzip -o $AkismetZip | awk -F "/" '{print $2}' >> $LOG 2>&1
rm $AkismetZip >> $LOG 2>&1

# Apaga a versão antiga do Plugin Google Site Kit #
echo "Apagando a versão antiga do Google Site Kit" >> $LOG
rm -rf $Plugins/google-site-kit/ >> $LOG 2>&1

# Faz o download da versão mais atual do plugin Google Site Kit #
echo "Download da versão mais atual do Google Site Kit" >> $LOG
cd $Plugins && wget https://downloads.wordpress.org/plugin/$VersaoGoogleKit >> $LOG 2>&1

# Retira o zip do Google Site Kit e exclui o arquivo .zip #
unzip -o $GoogleKitZip | awk -F "/" '{print $2}' >> $LOG 2>&1
rm $GoogleKitZip >> $LOG 2>&1

# Apaga a versão antiga do tema Twenty-One #
echo "Apagando a versão antiga do tema Twenty Twenty-One" >> $LOG
rm -rf $Themes/twentytwentyone/ >> $LOG 2>&1

# Faz o download da versão mais atual do tema Twenty-One #
echo "Download da versão mais atual do tema Twenty Twenty-One" >> $LOG
cd $Themes && wget https://downloads.wordpress.org/theme$VersaoTwentyOne >> $LOG 2>&1

# Retira o zip do tema Twenty-One e exclui o arquivo .zip #
VersaoTwentyOne_=$(echo $VersaoTwentyOne | awk -F "/" '{print $2}') >> $LOG 2>&1
unzip -o $VersaoTwentyOne_ >> $LOG 2>&1
rm $VersaoTwentyOne >> $LOG 2>&1

# Apaga a versão antiga do tema daily-blog #
echo "Apagando a versão antiga do tema Twenty Twenty-One" >> $LOG
rm -rf $Themes/daily-blog/ >> $LOG 2>&1

# Faz o download da versão mais atual do tema daily-blog #
echo "Download da versão mais atual do tema Twenty Twenty-One" >> $LOG
cd $Themes && wget https://downloads.wordpress.org/theme$VersaoDailyBlog >> $LOG 2>&1

# Retira o zip do tema daily-blog e exclui o arquivo .zip #
VersaoDailyBlog_=$(echo $VersaoDailyBlog | awk -F "/" '{print $2}') >> $LOG 2>&1
unzip -o $VersaoDailyBlog_ >> $LOG 2>&1
rm $VersaoDailyBlog >> $LOG 2>&1

# Reiniciando o apache #
echo "Reiniciando o Apache" >> $LOG
/etc/init.d/apache2 restart >> $LOG 2>&1
