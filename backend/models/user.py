from flask_sqlalchemy import SQLAlchemy
from flask_marshmallow import Marshmallow
db = SQLAlchemy()
ma = Marshmallow()


class User(db.Model):
    # class corresponding to the Incident Table in the database
    id = db.Column(db.Integer, primary_key=True)
    telephone = db.Column(db.String(10), nullable=False)
    first_name = db.Column(db.String(45), nullable=False)
    last_name = db.Column(db.String(45), nullable=False)
    nic_number = db.Column(db.String(20), nullable=True)
    email = db.Column(db.String(45), nullable=True)
    password = db.Column(db.String(45), nullable=False)

    def __init__(self, telephone, first_name, last_name, nic_number, email, password):
        self.telephone = telephone
        self.first_name = first_name
        self.last_name = last_name
        self.nic_number = nic_number
        self.email = email
        self.password = password

    # def add_user():


class UserSchema(ma.Schema):
    # user schema
    class Meta:
        fields = ('id', 'telephone', 'first_name', 'last_name',
                  'nic_number', 'email', 'password')


# init schema
user_schema = UserSchema()
users_schema = UserSchema(many=True)
