#!/bin/bash

# Criar função para exibir instruções de uso
usage() {
  echo "Modo de uso: ${0} [-dra] USUARIO..." >&2
  echo 'Desabilita usuários do sistema.'
  echo '   -d        Ao invés de desabilitar, o usuário será EXCLUÍDO do sistema.'
  echo '   -r        Remove diretório $HOME do usuário.'
  echo '   -a        Cria um backup do $HOME do usuário.'
  exit 1
}

# Garante que o script só é permitido com permissão de administrador
if [[ $(id -u $USER) -ne 0 ]]
then
  echo "Script permitido somente com permissão de administrador." >&2
  exit 1
fi

while getopts dra OPCAO
do
  case "${OPCAO}" in 
    d) 
      DELETE_ACCOUNT="true"
      ;;
    r)
      REMOVE_HOME_DIR="true"
      ;;
    a)
      BACKUP_HOME="true"
      ;;
    ?) 
      usage
      ;;
  esac
done

# Faz o shift dos argumentos para capturar a lista de usuários
shift $(( OPTIND -1 ))

if [[ "${#}" -eq 0 ]]
then
  usage
fi

for USUARIO in "${@}"
do
  if [[ -n "${DELETE_ACCOUNT}" ]]
  then
    COMANDO_OPTS=""
    if [[ -n "${REMOVE_HOME_DIR}" ]] 
    then
      COMANDO_OPTS="-r"  
    fi
    if [[ -n "${BACKUP_HOME}" ]] 
    then
      mkdir -p /archives/$USUARIO && tar -zcf /archives/$USUARIO-bkp.tar.gz /home/$USUARIO
      if [[ "${?}" -gt 0 ]]
      then
        echo "Não foi possível efetuar o backup para o usuário ${USUARIO}!" >&2
      fi
    fi
    COMANDO="userdel ${COMANDO_OPTS} ${USUARIO}"
  else
    COMANDO="chage -E0 $USUARIO" 
  fi
  
  # Não deixar excluir usuários administrativos
  if [[ $(id -u $USUARIO) -gt 1000 ]]
  then
    sh -c "${COMANDO}"
    if [[ "${?}" -eq 0 ]]
    then
      echo "Usuário ${USUARIO} excluído/desabilitado com sucesso."
    else
      echo "Erro ao desabilitar excluir o usuário ${USUARIO}." >&2
    fi 
  fi
done
