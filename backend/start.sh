#!/bin/bash

# RUN THIS TO RUN FLASK BACKEND EVERYTIME THE PROJECT IS RUN

# activating the environment
. venv/Scripts/activate

# selecting flask init file
export FLASK_APP=init.py

# running FLASK server
flask run