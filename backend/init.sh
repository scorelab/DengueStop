#!/bin/bash

# RUN ONLY ON THE FIRST RUN TO INITIALIZE FLASK

# installing virtualenv
pip install virtualenv

# configuring vitualenv for the first time
py -3 -m venv venv

# activating the environment
. venv/Scripts/activate

# installing required dependencies from the requirements.txt file
pip install -r requirements.txt

# initialize flask-migrate repository
flask db init

# migrate the new changes into the flask-migrate repository/folder
flask db migrate

# confirm changes and do the initial db operations such as creating tables with relations
flask db upgrade

# exiting virtualenv
deactivate
