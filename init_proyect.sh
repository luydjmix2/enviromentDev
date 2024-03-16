#!/bin/bash

#inclusiones
source /functions.sh

# Definir max_length
max_length=10  
# Obtener el nombre del directorio actual
current_dir_name=$(basename "$PWD")
# Nombre esperado del directorio desde el cual se debe ejecutar el script
folderProyects="proyectsNes"
# Ruta de la estructura del proyecto
readme_path="$base_path/$camel_case_name/docs/README.md"
base_path="$PWD/$folderProyects/Proyects/$tech_name/$version"
# Ruta al README.md dentro de la estructura del proyecto
readme_path="$base_path/$camel_case_name/docs/README.md"
# Correo de contacto
email_contact="luydjmix@gamil.com"
#definir fecha
current_date=$(date "+%Y-%m-%d")  


# Dar permisos de ejecución al script
chmod +x functions.sh
# Función para convertir una cadena a camelCase según las reglas especificadas
toCamelCase() {
  local input="$1"
  local result=""
  local current_length=0

  # Convertir cada palabra a camelCase
  for word in $input; do
    if [ $current_length -eq 0 ]; then
      result+=$(echo -n "${word^}")
    else
      result+=$(echo -n "${word:0:1}${word:1:3}" | tr '[:upper:]' '[:lower:]')
    fi

    # Actualizar la longitud total del nombre
    current_length=$((${#result} + 1))  # Sumar 1 para el carácter en mayúscula al inicio
    if [ $current_length -ge 18 ]; then
      break
    fi
  done

  echo "$result"
}

# Verificar si el script se ejecuta desde el directorio esperado
if [ "$current_dir_name" != "$folderProyects" ]; then
    echo "Por favor, asegúrese de ejecutar este script desde dentro de la carpeta '$folderProyects'."
    exit 1
fi

# Función para verificar y crear la estructura de carpetas para tecnología y versión
checkAndCreateFolder() {
  local tech_folder="$PWD/$1"
  local version_folder="$tech_folder/$2"

  if [ ! -d "$tech_folder" ]; then
    mkdir -p "$tech_folder"
  fi

  if [ ! -d "$version_folder" ]; then
    mkdir -p "$version_folder"
  fi
}

# Verificar el sistema operativo
OS=$(uname)
USER_HOME=$HOME


# Verificar y crear la estructura de carpetas para tecnología y versión
read -p "Ingrese la tecnología (php, node, python, etc.): " tech_name
read -p "Ingrese la versión de $tech_name (ej. 7.4, 10.1.11, 3.2, etc.): " version

checkAndCreateFolder "$tech_name" "$version"

# Solicitar el nombre del proyecto
read -p "Ingrese el nombre del proyecto: " project_name

# Eliminar espacios en blanco y acortar palabras
project_name_formatted=$(formatProjectName "$project_name" "$max_length")
formatted_name=$(echo "$project_name_formatted" | awk -v max="$max_length" '{gsub(/ /, ""); for(i=1;i<=NF;i++) if (length($i)>max) $i=substr($i,1,max); print}')

# Formatear el nombre del proyecto como camelCase
camel_case_name=$(toCamelCase "$formatted_name")

# Crear la estructura de carpetas para el proyecto dentro de la carpeta proyectsNes, tecnología y versión
mkdir -p "$base_path/$camel_case_name/src"
mkdir -p "$base_path/$camel_case_name/docs"
mkdir -p "$base_path/$camel_case_name/resources"
mkdir -p "$base_path/$camel_case_name/tests"
mkdir -p "$base_path/$camel_case_name/deploy"

# Crear archivos base de despliegue
# Cloning the repo
git clone https://github.com/luydjmix2/initDocker.git "$base_path/$camel_case_name/deploy"

# Asumiendo que 'project_name_input' es el nombre del proyecto ingresado por el usuario
project_name_input="Nombre Del Proyecto Con Tildes"

# Transformar 'project_name_input' para 'NAME_PROYECT':
# 1. Reemplazar tildes.
# 2. Eliminar caracteres especiales.
# 3. Unir palabras con la primera letra de cada palabra en mayúscula.
NAME_PROYECT=$(echo "$project_name_formatted" | iconv -f UTF-8 -t ASCII//TRANSLIT | sed 's/[^a-zA-Z0-9 ]//g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2));}1' | tr -d ' ')

# Transformar 'NAME_PROYECT' a minúsculas para 'DOCKER_PROYECT'
DOCKER_PROYECT=$(echo "$NAME_PROYECT" | tr '[:upper:]' '[:lower:]')

# Modificar el archivo .env con los valores calculados
sed -i "s/^NAME_PROYECT=.*/NAME_PROYECT=$NAME_PROYECT/" "$base_path/$camel_case_name/deploy/.env"
sed -i "s/^DOCKER_PROYECT=.*/DOCKER_PROYECT=$DOCKER_PROYECT/" "$base_path/$camel_case_name/deploy/.env"

# Agregar contenido a .gitignore
echo "node_modules/" >> "$camel_case_name/.gitignore"
echo ".env" >> "$camel_case_name/.gitignore"


# Crear README.md y escribir la primera línea
echo "# Proyecto $project_name" > "$readme_path"

# Agregar contenido al README.md
echo -e "\n## Información General" >> "$readme_path"
echo -e "Tecnología: $tech_name" >> "$readme_path"
echo -e "Versión: $version" >> "$readme_path"
echo -e "Framework: $NAME_FRAMEWORK" >> "$readme_path"
echo -e "Nombre del Proyecto: $project_name" >> "$readme_path"
echo -e "Fecha de Creación: $current_date" >> "$readme_path"
echo -e "Contacto: $email_contact" >> "$readme_path"

# Ejemplo de estilo bovino, asumiendo que es algo informal y amigable
echo -e "\n## 🐄 Sobre Nosotros" >> "$readme_path"
echo -e "¡Muuu! Somos un equipo apasionado por la tecnología, siempre listos para enfrentar nuevos retos y aprender. No dudes en contactarnos para cualquier consulta o para unirte a nuestra manada tecnológica." >> "$readme_path"


# Dar permisos de ejecución al script
chmod +x init_project.sh

echo "Estructura de carpetas y archivos creada exitosamente para el proyecto $camel_case_name."