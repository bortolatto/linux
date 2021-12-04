#!/bin/bash

usage() {
   echo "Modo de usar: " >&2
   echo "    ${0} -q{quantidade} -f{arquivo} -i{semente}" >&2
   echo "      -q  Quantidade de arquivos a serem gerados no arquivo" >&2
   echo "      -f  Nome do arquivo json que foi exportado o avro (sem formatacao)" >&2
   echo "      -i Número da CDA inicial para que o script gere números a partir deste" >&2
   exit 1
}

unset NUMERO_REGISTROS
unset NOME_ARQUIVO
unset NUMERO_INICIAL

if [[ "${#}" -eq 0 ]]
then
  usage
fi

while getopts q:f:i: OPCAO 
do
  case $OPCAO in
    q) NUMERO_REGISTROS=$OPTARG ;;
    f) NOME_ARQUIVO=$OPTARG ;;
    i) NUMERO_INICIAL=$OPTARG ;;
    *) usage 
       ;;
  esac
done

shift $(( OPTIND -1 ))

while [[ 1 -le $NUMERO_REGISTROS ]]
do
  IDENTIFICADOR=$(cat ${NOME_ARQUIVO} | awk -F '"' '{print $4}')
  CDA=$(cat ${NOME_ARQUIVO} | awk -F '"' '{print $8}')

  NUMERO_INICIAL=$(( NUMERO_INICIAL + 1 ))
  IDENTIFICADOR_FORMATADO=`printf "%015d" $(( 10#${NUMERO_INICIAL} ))`

  cat $NOME_ARQUIVO | sed "0,/${IDENTIFICADOR}/{s/${IDENTIFICADOR}/${IDENTIFICADOR_FORMATADO}/}" | sed "s/${CDA}/${NUMERO_INICIAL}/" >> novo-${NOME_ARQUIVO}
  NUMERO_REGISTROS=$(( NUMERO_REGISTROS - 1 ))
done

#rm $NOME_ARQUIVO
echo 'Terminou!'
exit 0
