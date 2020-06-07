#!/bin/bash

# RUN THIS TO RUN FLASK BACKEND EVERYTIME THE PROJECT IS RUN

# activating the environment
echo 'Activating Environment...'
. venv/Scripts/activate

# selecting flask init file
export FLASK_APP=init.py

# running FLASK server
# only used for test purposes not to be used in production!!!
flask run