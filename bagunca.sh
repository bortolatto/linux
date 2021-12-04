#!/bin/bash

usage() {
   echo "Modo de usar: " >&2
   echo "    ${0} -n{quantidade} -f{arquivo} -ni{semente}" >&2
   echo "      -n  Quantidade de arquivos a serem gerados no arquivo" >&2
   echo "      -f  Nome do arquivo json que foi exportado o avro (sem formatacao)" >&2
   echo "      -ni Número da CDA inicial para que o script gere números a partir deste" >&2
   exit 1
}

if [[ -n "${@}" || "${OPTIND}" -eq 1 ]]
then
   usage
fi

while getopts n:f:ni: OPCAO 
do
  case ${OPCAO} in
    n) NUMERO_REGISTROS=${OPTARG} ;;
    f) NOME_ARQUIVO=${OPTARG} ;;
    ni) NUMERO_INICIAL=${OPTARG} ;;
    ?) usage 
       ;;
  esac
done

echo $OPTIND

while [[ 1 -le $NUMERO_REGISTROS ]]
do
  IDENTIFICADOR=$(cat ${NOME_ARQUIVO} | awk -F '"' '{print $4}')
  CDA=$(cat ${NOME_ARQUIVO} | awk -F '"' '{print $8}')

  NUMERO_INICIAL=$(( NUMERO_INICIAL + 1 ))
  IDENTIFICADOR_FORMATADO=`printf "%015d" $(( 10#${NUMERO_INICIAL} ))`

  cat $NOME_ARQUIVO | sed "0,/${IDENTIFICADOR}/{s/${IDENTIFICADOR}/${IDENTIFICADOR_FORMATADO}/}" | sed "s/${CDA}/${NUMERO_INICIAL}/" >> novo-${NOME_ARQUIVO}
  NUMERO_REGISTROS=$(( NUMERO_REGISTROS - 1 ))
done

rm $NOME_ARQUIVO
echo 'Terminou!'
exit 0
