#!/bin/bash

# Criar usuários utilizando um superuser

# Verifica se o usuário executando o script é um superuser
UID_TO_TEST_FOR=$UID

if [[ "${UID_TO_TEST_FOR}" -ne 0 ]]
then
  echo "You are not root. Exiting script." >&2
  exit 1
fi

# Verifica se foi informado ao menos um argumento
if [[ "${#}" -lt 1 ]]
then
  echo "Usage: ${0} USER_NAME [COMMENT]..." >&2
  echo "Create an account on the local system with the name of USER_NAME and a comments field of COMMENT." >&2
  exit 1
fi

USER_NAME_TO_CREATE=$1
shift 1
COMMENTS=${@}

# Criar o usuário no sistema
useradd -m ${USER_NAME_TO_CREATE} -c "${COMMENTS}" &> /dev/null # ou: > /dev/null 2>&1

if [[ "${?}" -ne 0 ]]
then
  echo 'The user account was not able to be created.' >&2
  exit 1
fi 

# Configura a senha para o usuário
PASSWD=$(date +%s%N | sha256sum | head -c48) 
echo "${PASSWD}" | passwd --stdin ${USER_NAME_TO_CREATE} > /dev/null

# Expira a senha
passwd -e ${USER_NAME_TO_CREATE} > /dev/null

echo "username:"
echo "${USER_NAME_TO_CREATE}"
echo
echo "password:"
echo "${PASSWD}"
echo
echo "host:"
echo "${HOSTNAME}"
