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