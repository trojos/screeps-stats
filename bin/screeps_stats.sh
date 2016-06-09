#!/usr/bin/env bash

# Ths wrapper script activated the virtual environment before calling the
# statsrunner.py program. It also makes sure the application is not run as
# the root user.

USER='screepsstats'

# Get real directory in case of symlink
if [[ -L "${BASH_SOURCE[0]}" ]]
then
  DIR="$( cd "$( dirname $( readlink "${BASH_SOURCE[0]}" ) )" && pwd )"
else
  DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
fi
cd $DIR

ENV="$DIR/../env/bin/activate"
if [ ! -f $ENV ]; then
    echo 'Virtual Environment Not Installed'
fi

SCRIPT="$DIR/../screeps_etl/statsrunner.py"

if (( "$EUID" == 0 )); then
  su - $USER -s /bin/bash -c "source $ENV; $SCRIPT $@"
else
  $SCRIPT "$@"
fi
