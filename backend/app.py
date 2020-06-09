from models.user import User, user_schema
from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_marshmallow import Marshmallow

import os

# init app
app = Flask(__name__)
basedir = os.path.abspath(os.path.dirname(__file__))
# database
# to supress the warning on the terminal, specify this line
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://root:test1234@localhost/dengue_stop'
# init DB
db = SQLAlchemy(app)
# init marshmallow
ma = Marshmallow(app)


@app.route('/', methods=['GET'])
def hello_world():
    return jsonify({'name': 'hello'})


@app.route('/register', methods=['POST'])
def register_user():
    print("HIT")
    telephone = request.json['telephone']
    print(telephone)
    print("TLEL")
    first_name = request.json['first_name']
    last_name = request.json['last_name']
    nic_number = request.json['nic_number']
    email = request.json['email']
    password = request.json['password']

    new_user = User(telephone, first_name, last_name,
                    nic_number, email, password)
    db.session.add(new_user)
    db.session.commit()

    return user_schema.jsonify(new_user)


# running server
if __name__ == '__main__':
    app.run(debug=True)
