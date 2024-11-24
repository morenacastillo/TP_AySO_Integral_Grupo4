#!/bin/bash
clear

###############################
#
# Parametros:
#  - Lista de Usuarios a crear
#  - Usuario del cual se obtendra la clave
#
#  Tareas:
#  - Crear los usuarios segun la lista recibida en los grupos descriptos
#  - Los usuarios deberan de tener la misma clave que la del usuario pasado por parametro
###############################

LISTA=$1
USUARIO_CLAVE=$2
CLAVE=$(sudo grep "$USUARIO_CLAVE" /etc/shadow | awk -F ':' '{print $2}')


ANT_IFS=$IFS
IFS=$'\n'
for LINEA in `cat $LISTA |  grep -v ^#`
do
	USUARIO=$(echo  $LINEA |awk -F ',' '{print $1}')
	GRUPO=$(echo  $LINEA |awk -F ',' '{print $2}')
	DIRECTORIO=$(echo  $LINEA |awk -F ',' '{print $3}')

	if ! getent group $GRUPO > /dev/null; then
    	echo "creando el grupo $GRUPO"
    	sudo groupadd $GRUPO
  	fi
	
	if id "$USUARIO" &>/dev/null; then
    	echo "El usuario $USUARIO ya existe."
  	else
	sudo useradd -m -s /bin/bash -g $GRUPO -d $DIRECTORIO -p "$CLAVE" $USUARIO
	echo "Usuario: $(sudo grep "$USUARIO" /etc/shadow) - grupos: $(id $USUARIO) "
	fi
done
IFS=$ANT_IFS
