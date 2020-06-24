#!/bin/bash

# RUN THIS TO RUN FLASK BACKEND EVERYTIME THE PROJECT IS RUN

# activating the environment
echo 'Activating Environment...'
. venv/Scripts/activate

# running app.py 
export FLASK_APP=app.py
export FLASK_ENV=development

flask run
