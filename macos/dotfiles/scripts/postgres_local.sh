#!/bin/zsh

CONTAINER_NAME="postgres_local"
CONTAINER_IMAGE="postgres:16.4"
POSTGRES_PASSWORD=postgres
POSTGRES_DATABASE=public

start_postgres() {
  if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    echo "postgres container is already running."
  else
    echo "Starting postgres container..."
    docker run --name $CONTAINER_NAME -e POSTGRES_PASSWORD=$POSTGRES_PASSWORD \
      -e POSTGRES_DB=$POSTGRES_DATABASE -p 5432:5432 -d $CONTAINER_IMAGE
    echo "PostgreSQL service started with username: postgres and database: public"
  fi
}

stop_postgres() {
  if [ "$(docker ps -q -f name=$CONATINER_NAME)" ]; then
    echo "Stoping postgres container..."
    docker stop $CONTAINER_NAME
    docker rm $CONTAINER_NAME
    echo "postgres container stopped and removed."
  else
    echo "postgres container is not running"
  fi
}

status_postgres() {
  if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    echo "postgres container is running."
  else
    echo "postgres container is not running."
  fi
}

case "$1" in
  start)
    start_postgres
    ;;
  stop)
    stop_postgres
    ;;
  status)
    status_postgres
    ;;
  *)
    echo "Usage: $0 {start|stop|status}"
    exit 1
    ;;
esac

exit 0
