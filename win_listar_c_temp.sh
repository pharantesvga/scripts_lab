#!/bin/bash

# Verifica se pelo menos o inventário foi fornecido
if [ "$#" -lt 1 ]; then
    echo "Erro: Parâmetros obrigatórios faltando!"
    echo "Uso: $0 <caminho_do_inventario> [host1,host2...]"
    echo "Exemplo 1: $0 /opt/inv/inventario.ini"
    echo "Exemplo 2: $0 /opt/inv/inventario.ini host1"
    echo "Exemplo 3: $0 /opt/inv/inventario.ini host1,host2"
    exit 1
fi

INVENTARIO="$1"
HOSTS="windows"  # Padrão para todos os hosts do grupo windows

# Se o segundo parâmetro existir, substitui a lista de hosts
if [ -n "$2" ]; then
    HOSTS=$(echo "$2" | tr '[:lower:]' '[:upper:]')
fi

# Executa o comando Ansible
ansible $HOSTS -i $INVENTARIO -m win_shell -a "ls c:\temp"
