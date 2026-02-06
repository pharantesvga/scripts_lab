##################################################
#LIMPEZA
docker container stop $(docker container ps -aq)
docker container rm $(docker container ps -a -q)
docker volume prune -a -f
docker image prune -a -f
docker system prune -f
docker system prune -a --volumes -f

##################################################
################## Instalações

#MONGO
docker network create mongo-network

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

#REDIS
docker run -d --name redis \
-p 6379:6379 \
-p 8001:8001 \
redis/redis-stack:latest

#NEO4J
docker run -d \
--publish=7474:7474 --publish=7687:7687 \
--env NEO4J_AUTH=neo4j/cefetmgcefetmg \
--name neo4j neo4j:latest

#CASSANDRA
docker run -d --name cassandra \
-p 9042:9042 \
-v /home/alunos/docker:/var/lib/cassandra \
cassandra:latest

#PORTAINER
docker run -d \
-p 9000:9000 \
--restart=always \
-v /var/run/docker.sock:/var/run/docker.sock \
--name portainer \
portainer/portainer-ce:latest

#NODERED
docker run -d \
-p 1880:1880 \
-v node_red_data:/data \
--restart=always \
--name nodered \
nodered/node-red:latest