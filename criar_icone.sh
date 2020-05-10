#!/bin/bash

# Autor: Marcos Garcia
# Versão: 0.1
# Versão do bash 4.4.20

# Script utilizado para criar icones no laucher
# Sempre executar com o sudo ou usuário root

# Comando para execução: sudo bash criar_icone.sh

# Evite executar com o comando (sh), por conta de compatibilidade de componentes

# Necessário ter a depencência do Zenity instalada
# Verifique existe a depêndencia com o comando (zenity --version), caso não exista instale com o comando abaixo:
# apt install zenity
#==================================================================================================================

informacoes=""

quantidade_das_informacoes() {
   _count=0
   _qtde=$(echo $informacoes | tr "|" "\n" | tr " " ";")
   for i in $_qtde; do
      _count=$(($_count+1))
   done
   return $_count
}

validar() {
   if [ ! $1 -eq 4 ]; then
      zenity --error --title="Erro" --text="Preencha todos os campos do formulário" --width="250"
      sh criar_icones.sh
   fi
}

montar() {
   y=0
   _info=$(echo $informacoes | tr "|" "\n" | tr " " ";")
   for x in $_info; do
      list[y]=$x
      y=$(($y+1))
   done

   arquivo="${list[0]}.desktop"
   > $arquivo

   echo "[Desktop Entry]" >> $arquivo
   echo "Type=Application" >> $arquivo
   echo "Name="${list[0]} | tr ";" " " >> $arquivo
   echo "Icon="${list[1]} | tr ";" " " >> $arquivo
   echo "Comment="${list[2]} | tr ";" " " >> $arquivo
   echo "Exec=${list[3]}" >> $arquivo
   echo "Terminal=false" >> $arquivo
   echo "Type=Application" >> $arquivo

   cp $arquivo /usr/share/applications/
   rm $arquivo
}

gerar_formulario() {
   informacoes=`zenity --forms --title="Criando seu icone" --text="Informações necessárias" --width="400" --height="200" \
                           --add-entry="Nome da aplicação" \
                           --add-entry="Icone da aplicação" \
                           --add-entry="Descrição da aplicação" \
                           --add-entry="Caminha do executavel" \
                           --separator="|"`

   case $? in
      0)
         quantidade_das_informacoes
         resposta=$?
         validar $resposta
         montar
         ;;
      1)
         exit 0;;
   esac
}

verificar_usuario() {
   if [ ! $UID -eq 0 ]; then
      echo "================= # Alerta # =============="
      echo "Execute o script com sudo, ou usuário root"
      echo "==========================================="
      exit 0
   fi
}

iniciar() {
   verificar_usuario
   gerar_formulario
}

iniciar

