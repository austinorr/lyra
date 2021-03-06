@ECHO off    
if /i "%1" == "" goto :help
if /i %1 == help goto :help
if /i %1 == clean goto :clean
if /i %1 == test goto :test
if /i %1 == develop goto :develop
if /i %1 == prod goto :prod
if /i %1 == up goto :up
if /i %1 == down goto :down
if /i %1 == typecheck goto :typecheck
if /i %1 == coverage goto :coverage
if /i %1 == dev-server goto :dev-server
if /i %1 == restart goto :restart
if /i %1 == env goto :env

:help
echo Commands:
echo   - clean       : removes caches and old test/coverage reports
echo   - test        : runs tests and integration tests in docker
echo   - develop     : builds/rebuilds the development containers
echo   - prod        : builds/rebuilds the production containers
echo   - up          : starts containers in '-d' mode
echo   - down        : stops containers and dismounts volumes
echo   - typecheck   : runs mypy typechecker
echo   - coverage    : calculates code coverage of tests within docker
echo   - dev-server  : starts a local development server with 'reload' and 'foreground' tasks
echo.
echo Usage:
echo $make [command]
goto :eof

:test
call make clean
call make restart
docker-compose exec base pytest %2 %3 %4 %5 %6
goto :eof

:typecheck
call make clean
call make restart
mypy --config-file=lyra/mypy.ini lyra
goto :eof

:develop
call make clean
scripts\build_dev.bat
call docker-compose -f docker-stack.yml build
goto :eof

:prod
call make clean
scripts\build_prod.bat
call docker-compose -f docker-stack.yml build
goto :eof

:up
docker-compose up -d
goto :eof

:down
docker-compose down -v
goto :eof

:clean
scripts\clean.bat
goto :eof

:dev-server
docker-compose run -p 8080:80 lyra bash /start-reload.sh
goto :eof

:restart
docker-compose restart redis celeryworker
goto :eof

:env
scripts\make_dev_env.bat
goto :eof
