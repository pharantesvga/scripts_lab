#!/bin/bash

# Função para mostrar ajuda
show_help() {
    echo "Uso: $0 <inventario> <arquivo_exe> [hosts]"
    echo "Exemplo 1: $0 /opt/inv/inventario.ini setup.exe"
    echo "Exemplo 2: $0 /opt/inv/inventario.ini installer.exe HOST1,HOST2"
    exit 1
}

# Verificação dos parâmetros obrigatórios
if [ "$#" -lt 2 ]; then
    echo "ERRO: Faltam parâmetros obrigatórios!"
    show_help
fi

INVENTARIO="$1"
ARQUIVO_EXE="$2"
HOSTS="windows"  # Valor padrão

# Processa o terceiro parâmetro se existir
if [ -n "$3" ]; then
    HOSTS=$(echo "$3" | tr '[:lower:]' '[:upper:]')
fi

# Verifica se o arquivo de inventário existe
if [ ! -f "$INVENTARIO" ]; then
    echo "ERRO: Arquivo de inventário não encontrado: $INVENTARIO"
    exit 1
fi

# Monta o comando que será executado
COMANDO="ansible \"$HOSTS\" -i \"$INVENTARIO\" -m win_shell -a \"Start-Process -FilePath 'C:\\Temp\\$ARQUIVO_EXE' -ArgumentList '/S' -Wait\""

# Mostra o comando para confirmação
echo "--------------------------------------------------"
echo "COMANDO QUE SERÁ EXECUTADO:"
echo "$COMANDO"
echo "--------------------------------------------------"

# Confirmação do usuário
read -p "Deseja executar este comando? (s/n): " RESPOSTA
RESPOSTA=$(echo "$RESPOSTA" | tr '[:upper:]' '[:lower:]')

if [ "$RESPOSTA" != "s" ]; then
    echo "Execução cancelada pelo usuário."
    exit 0
fi

# Executa o comando
eval "$COMANDO"
