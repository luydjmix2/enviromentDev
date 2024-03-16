#!/bin/bash

# Función para formatear el nombre del proyecto según las especificaciones dadas
formatProjectName() {
    local input="$1"
    local max_length="$2"
    local formatted=""
    local total_length=0
	
	# Separar palabras CamelCase en palabras individuales, si es necesario
    input=$(splitCamelCase "$input")
	
    # Convertir el input a ASCII, eliminar caracteres especiales y calcular longitud total
    input=$(echo "$input" | iconv -f UTF-8 -t ASCII//TRANSLIT | sed 's/[^a-zA-Z0-9 ]//g')
    
    # Calcular la longitud total de las palabras sin espacios
    total_length=$(echo -n "$input" | tr -d ' ' | wc -c)

    # Si la longitud total supera max_length, acortar cada palabra a 4 letras
    if [ "$total_length" -gt "$max_length" ]; then
        for word in $input; do
            # Acortar cada palabra a 4 letras y convertir a CamelCase
            word=$(echo "${word:0:4}" | awk '{print toupper(substr($0,1,1)) tolower(substr($0,2))}')
            formatted+="$word"
        done
    else
        # Si no supera max_length, simplemente convertir a CamelCase
        for word in $input; do
            word=$(echo "$word" | awk '{print toupper(substr($0,1,1)) tolower(substr($0,2))}')
            formatted+="$word"
        done
    fi

    echo "$formatted"
}


splitCamelCase() {
    local input="$1"
    local splitText=""
    
    # Leer cada palabra/parte del input
    IFS=' ' read -ra ADDR <<< "$input"
    for i in "${ADDR[@]}"; do
        # Si la parte parece estar en CamelCase (contiene mayúsculas no iniciales),
        # la separamos. De lo contrario, la dejamos como está.
        if [[ $i =~ [a-z]+[A-Z] ]]; then
            # Separar la parte CamelCase e insertar espacios
            i=$(echo "$i" | sed -r 's/([a-z0-9])([A-Z])/\1 \2/g' | tr '[:upper:]' '[:lower:]')
        fi
        splitText+="$i "
    done
    
    echo "$splitText"
}
# Función para verificar y crear la estructura de carpetas para tecnología y versión
checkAndCreateFolder() {
  local tech_folder="$PWD/Languages/$1"
  local version_folder="$tech_folder/$2"

  if [ ! -d "$tech_folder" ]; then
    mkdir -p "$tech_folder"
  fi

  if [ ! -d "$version_folder" ]; then
    mkdir -p "$version_folder"
  fi
}


# Función para limpiar la entrada eliminando puntos y espacios en blanco no deseados al principio y al final,
# manteniendo el guion medio si está presente en el medio del texto
sanitizeInput() {
    local input="$1"
    # Eliminar puntos y espacios en blanco no deseados al principio y al final
    input=$(echo "$input" | sed 's/^[[:space:]]*\.//; s/\.$//; s/[[:space:]]*$//')
    # Mantener el guion medio si está presente en el medio del texto
    input=$(echo "$input" | sed 's/^\(.*\)-\(.*\)$/\1-\2/')
    echo "$input"
}
