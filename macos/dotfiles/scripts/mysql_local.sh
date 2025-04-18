#!/bin/zsh

CONTAINER_NAME="mysql_local"
CONTAINER_IMAGE="mysql:8.4"
MYSQL_ROOT_PASSWORD=root
MYSQL_DATABASE=public

start_mysql() {
  if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    echo "MySQL container is already running."
  else
    echo "Starting MySQL container..."
    docker run --name $CONTAINER_NAME -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD \
      -e MYSQL_DATABASE=$MYSQL_DATABASE -p 3306:3306 -d $CONTAINER_IMAGE
    echo "MySQL service started with username: root and database: public"
  fi
}

stop_mysql() {
  if [ "$(docker ps -q -f name=$CONATINER_NAME)" ]; then
    echo "Stoping MySQL container..."
    docker stop $CONTAINER_NAME
    docker rm $CONTAINER_NAME
    echo "MySQL container stopped and removed."
  else
    echo "MySQL container is not running"
  fi
}

status_mysql() {
  if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    echo "MySQL container is running."
  else
    echo "MySQL container is not running."
  fi
}

case "$1" in
  start)
    start_mysql
    ;;
  stop)
    stop_mysql
    ;;
  status)
    status_mysql
    ;;
  *)
    echo "Usage: $0 {start|stop|status}"
    exit 1
    ;;
esac

exit 0
