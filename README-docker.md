## Setup
- add `export DOCKER_DEVELOPMENT=1` to your `.profile` or `.bashrc`

### Mac
- `brew update && brew install brew-cask`
- `brew cask install dockertoolbox`

## Build and Initial Run
- `docker-machine restart default` (start VM)
- `docker-compose build` (run container setup scripts)
- `docker-compose up` (load containers)
- `script/bootstrap-docker` (initialize database)
