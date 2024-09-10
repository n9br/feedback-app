docker network create feedback-app-nw

docker run \
    --name postgres-db \
    --network feedback-app-nw \
    -p 5432:5432 \
    -e POSTGRES_PASSWORD=password \
    -e POSTGRES_DB=feedbackdb \
    -v feedback-app-data:/var/lib/postgresql/data \
    -d \
    postgres

docker run \
    --name feedback-app \
    --network feedback-app-nw \
    -p 3030:3000 \
    -d \
    feedback-app