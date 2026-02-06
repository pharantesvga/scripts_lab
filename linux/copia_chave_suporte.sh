#!/bin/bash

SENHA="!@sptCFT!@"

for i in $(seq 45 45); do
  echo "=== Copiando chave para 200.128.159.$i ==="
  sshpass -p "$SENHA" ssh-copy-id -o StrictHostKeyChecking=no suporte@200.128.159.$i
done

