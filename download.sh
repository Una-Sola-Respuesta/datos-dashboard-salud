#!/bin/bash

set -e

declare -a datasets=(
    "casos https://covid19datos.salud.gov.pr/estadisticas_v2/download/data/casos/completo"
    "defunciones https://covid19datos.salud.gov.pr/estadisticas_v2/download/data/defunciones/completo"
    "sistemas_de_salud https://covid19datos.salud.gov.pr/estadisticas_v2/download/data/sistemas_salud/completo")

for dataset in "${datasets[@]}"; do
  array=($dataset)

  name=${array[0]}
  url=${array[1]}

  echo "• Creando directorio: $name"
  mkdir -p ./$name

  echo "• Descargando: $url"
  filename="$name/${name}_$(date +"%Y_%m_%dT%H_%M").csv"
  curl -sSk "$url" -o "$filename"

  echo "• Calculando MD5 de: $filename"
  md5=($(md5sum "$filename"))
  echo "• MD5: $md5"

  echo "• Añadiendo record de descarga"
  timestamp=$(date +'%Y-%m-%d %H:%M:%S.%6N')
  echo "$timestamp,$url,$md5" >> data_pulls_md5_history.csv

  echo ""
done
