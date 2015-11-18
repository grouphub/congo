## Initial Setup
- add `eval "$(docker-machine env default)"` to your `~/.profile` or `~/.bashrc`

### Mac
- `brew update && brew install caskroom/cask/brew-cask`
- `brew cask install dockertoolbox`

## Build and Initial Run
- `docker-machine restart default` (start VM)
- `eval "$(docker-machine env default)"` (or `source ~/.profile`, etc.)
- `docker-compose build` (run container setup scripts)
- `docker-compose up` (load containers)
- `script/bootstrap-docker` (initialize database)
