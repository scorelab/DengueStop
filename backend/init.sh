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

# exiting virtualenv
deactivate
