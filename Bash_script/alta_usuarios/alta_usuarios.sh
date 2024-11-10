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
#
###############################

if [ $# -lt 2 ]; then
  echo "Error: Se requiere el archivo de usuarios y el usuario para la clave."
  echo "Uso: $0 <archivo_lista_usuarios> <usuario_contraseña>"
  exit 1
fi

LISTA=$1
USUARIO_CLAVE=$2
CLAVE=$(sudo grep "$USUARIO_CLAVE" /etc/shadow | awk -F ':' '{print $2}')

if [ -z "$CLAVE" ]; then
  echo "Error: No se pudo obtener la contraseña del usuario $USUARIO_CLAVE."
  exit 1
fi


ANT_IFS=$IFS
IFS=$'\n'
for LINEA in `cat $LISTA |  grep -v ^#`
do
	USUARIO=$(echo  $LINEA |awk -F ',' '{print $1}')
	GRUPO=$(echo  $LINEA |awk -F ',' '{print $2}')
	DIRECTORIO=$(echo  $LINEA |awk -F ',' '{print $3}')

	if ! getent group $GRUPO > /dev/null; then
    	echo "Error: El grupo $GRUPO no existe. Creando el grupo..."
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
