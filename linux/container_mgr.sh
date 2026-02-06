#!/bin/bash

# Lista de containers gerenciados
CONTAINERS=("nodered" "portainer" "cassandra" "neo4j" "redis" "mongo-express" "mongo")

# Funções de instalação (copiadas do arquivo fornecido)
instalar_mongo() {
    docker network create mongo-network 2>/dev/null
    docker run -d \
    --name mongo \
    -p 27017:27017 \
    -v /home/alunos/docker/mongo:/data/db \
    --network mongo-network \
    mongo:latest

    docker run -d \
    --name mongo-express \
    -p 8081:8081 \
    --network mongo-network \
    --link mongo:mongo \
    -e ME_CONFIG_BASICAUTH_USERNAME=alunos \
    -e ME_CONFIG_BASICAUTH_PASSWORD=cefetmg \
    -e ME_CONFIG_MONGODB_PORT=27017 \
    -e ME_CONFIG_MONGODB_ENABLE_ADMIN=true \
    -e ME_CONFIG_MONGODB_SERVER=mongo \
    mongo-express:latest
}

instalar_redis() {
    docker run -d --name redis \
    -p 6379:6379 \
    -p 8001:8001 \
    redis/redis-stack:latest
}

instalar_neo4j() {
    docker run -d \
    --publish=7474:7474 --publish=7687:7687 \
    --env NEO4J_AUTH=neo4j/cefetmgcefetmg \
    --name neo4j neo4j:latest
}

instalar_cassandra() {
    docker run -d --name cassandra \
    -p 9042:9042 \
    -v /home/alunos/docker:/var/lib/cassandra \
    cassandra:latest
}

instalar_portainer() {
    docker run -d \
    -p 9000:9000 \
    --restart=always \
    -v /var/run/docker.sock:/var/run/docker.sock \
    --name portainer \
    portainer/portainer-ce:latest
}

instalar_nodered() {
    docker run -d \
    -p 1880:1880 \
    -v node_red_data:/data \
    --restart=always \
    --name nodered \
    nodered/node-red:latest
}

# Limpar tudo, exceto os containers do script
limpar_exceto() {
    docker rm -f $(docker ps -a --format '{{.ID}} {{.Names}}' | \
    grep -v -E "$(IFS=\|; echo "${CONTAINERS[*]}")" | awk '{print $1}') 2>/dev/null
}

# Limpeza total
limpar_tudo() {
    docker container stop $(docker container ps -aq) 2>/dev/null
    docker container rm $(docker container ps -aq) 2>/dev/null
    docker volume prune -a -f
    docker image prune -a -f
    docker system prune -a --volumes -f
}

# Listar containers gerenciados
listar_containers() {
    docker ps -a
}

# Menu principal
while true; do
    clear
    echo "===== MENU DOCKER ====="
    echo "1) Instalar Mongo + Mongo Express"
    echo "2) Instalar Redis"
    echo "3) Instalar Neo4j"
    echo "4) Instalar Cassandra"
    echo "5) Instalar Portainer"
    echo "6) Instalar Node-RED"
    echo "7) Limpar tudo EXCETO containers instalados pelo script"
    echo "8) Limpeza geral (tudo)"
    echo "9) Listar todos containers"
    echo "0) Sair"
    echo "======================="
    read -p "Escolha uma opção: " opcao

    case $opcao in
        1) instalar_mongo ;;
        2) instalar_redis ;;
        3) instalar_neo4j ;;
        4) instalar_cassandra ;;
        5) instalar_portainer ;;
        6) instalar_nodered ;;
        7) limpar_exceto ;;
        8) limpar_tudo ;;
        9) listar_containers ;;
        0) exit ;;
        *) echo "Opção inválida!" ;;
    esac
    read -p "Pressione ENTER para continuar..."
done
