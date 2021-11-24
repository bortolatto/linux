#!/bin/bash

JAVA_BINARY="java -jar /home/bortolatto/Softplan/projects/pj-centralcda-conversor/libs/avro-tools-1.10.0.jar"

while getopts b:jv OPCAO
do
  case ${OPCAO} in
    b)
      BASE64=${OPTARG}
      ;;
    j)
      TOJSON="tojson"
      ;;  
    v)
      VERBOSE="true"
      ;;
    ?) 
      echo "Modo de usar:" >&2
      echo "   ${0} [-b base64] [-j (TOJSON) -v (VERBOSE)]"
      exit 1  
  esac
done

shift $(( OPTIND - 1 ))

if [[ -n "${BASE64}" ]]
then
  COMMAND="echo '${BASE64}' | base64 -d | ${JAVA_BINARY} tojson - | jq"
else
  ARGS=$@
  COMMAND="${JAVA_BINARY} ${ARGS}"
  if [[ -n "${TOJSON}" ]]
  then
    COMMAND="${JAVA_BINARY} ${TOJSON} ${ARGS} | jq" 
  fi
fi

if [[ "${VERBOSE}" = "true" ]]
then
  echo -----------------------
  echo "Comando: ${COMMAND}"
  echo -----------------------
fi

# Executar comando
sh -c "${COMMAND}"
