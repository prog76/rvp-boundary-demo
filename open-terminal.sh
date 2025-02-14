
#!/bin/bash
if ! docker inspect -f '{{.State.Running}}' terminal &> /dev/null; then
  echo "terminal not found creating..."
  docker-compose up -d --no-deps terminal --build
else
  echo "terminal is ready"
fi

docker exec -it terminal bash

docker-compose stop terminal
docker-compose rm --force terminal