#!/bin/bash

# Verifica se foi passado algum argumento para filtrar
if [ "$#" -eq 1 ]; then
    # Se foi passado um filtro, usa no grep
    FILTRO="$1"
    nbtscan -r 200.128.156.0/22 | grep "$FILTRO" | sort -k2
else
    # Se não foi passado filtro, executa sem grep (apenas ordena)
    nbtscan -r 200.128.156.0/22 | sort -k2
fi


