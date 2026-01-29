# Verifica se ao menos o parâmetro src foi informado
if [ "$#" -lt 2 ]; then
  echo "Argumento faltando!"
  echo "Modo de uso: $0 <inventario> <arq_origem> [pc_individual] [local_dest]"
  echo "inventario - obrigatorio"
  echo "arq_origem - obrigatorio"
  echo "local_dest - opcional - C:\Temp e o padrao"
  echo "pc_individual - opcional - padrao é o grupo [windows]"
  echo "Exemplo: win_copy.sh /opt/inv/L114-18061515 geany32bits.exe"
  echo "Exemplo: win copy.sh /opt/inv/L112-25051033 planilha.pdf GLABVG-L112-005 C:"
  exit 1
fi

INV="$1"
SRC="$2"
DEST="${4:-C:\\Temp}"  # Usa C:\Temp como padrão se não for informado

if [ -n "$3" ]; then
  PC="$3"
else
  PC="windows"
fi



# Exibe os caminhos para confirmação
echo
echo "O seguinte comando sera executado:"
echo "  Origem (src): $SRC"
echo "  Destino (dest): $DEST"
echo "ansible ${PC} -i ${INV} -m win_copy -a \"src='${SRC}' dest='${DEST}'\" \n"

# Pede confirmação
read -p "Confirmar e executar? (s/n): " CONFIRMA

# Apenas "s" (minúsculo) confirma; qualquer outra coisa cancela
if [ "$CONFIRMA" != "s" ]; then
  echo "Operação cancelada pelo usuário."
  exit 0
fi

# Executa o comando Ansible
echo "Executando comando..."
ansible $PC -i $INV -m win_copy -a "src='${SRC}' dest='${DEST}'"
