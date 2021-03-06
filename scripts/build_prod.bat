
set COMPOSE_FILE=docker-stack.yml

call docker-compose ^
-f docker-compose.shared.build.yml ^
-f docker-compose.shared.depends.yml ^
-f docker-compose.shared.env.yml ^
config > docker-stack.yml

docker-compose -f docker-stack.yml build
