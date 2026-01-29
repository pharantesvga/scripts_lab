#!/bin/bash

# Verifica se o filtro foi fornecido
if [ "$#" -ne 1 ]; then
    echo "Modo de usar o comando: $0 <filtro>"
    echo "Exemplo: $0 L114"
    exit 1
fi

FILTRO="$1"
DATA=$(date +"%d%m%H%M")
DIR_SAIDA="/opt/inv"
ARQUIVO_SAIDA="${DIR_SAIDA}/${FILTRO}_${DATA}_inventory"

# Cria diretório se não existir
mkdir -p "$DIR_SAIDA"

# Cabeçalho do arquivo
cat > "$ARQUIVO_SAIDA" <<EOF
[windows]
EOF

# Processa os hosts e adiciona ao inventário
nbtscan -r 200.128.156.0/22 | grep "$FILTRO" | sort -k2 | while read -r ip nome _; do
    # Remove caracteres inválidos do nome (como espaços)
    nome_clean=$(echo "$nome" | tr -d '\r' | tr -d ' ')
    echo "$nome_clean ansible_host=$ip" >> "$ARQUIVO_SAIDA"
done

# Adiciona as variáveis de conexão
cat >> "$ARQUIVO_SAIDA" <<EOF

[windows:vars]
ansible_connection=winrm
ansible_winrm_transport=ntlm
ansible_user=Admin
ansible_password=cefetmg
ansible_winrm_server_cert_validation=ignore
ansible_port=5985
EOF

echo "Inventário do Ansible gerado em: $ARQUIVO_SAIDA"
