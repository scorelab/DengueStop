from database import db
from database import ma


class User(db.Model):
    # class corresponding to the User Table in the database
    __tablename__ = 'user'
    id = db.Column(db.Integer, primary_key=True)
    telephone = db.Column(db.String(10), unique=True, nullable=False)
    first_name = db.Column(db.String(45), nullable=False)
    last_name = db.Column(db.String(45), nullable=False)
    nic_number = db.Column(db.String(20), nullable=True)
    email = db.Column(db.String(45), nullable=True)
    password = db.Column(db.String(45), nullable=False)
    salt = db.Column(db.String(45), nullable=False)

    def __init__(self, telephone, first_name, last_name, nic_number, email, password, salt):
        self.telephone = telephone
        self.first_name = first_name
        self.last_name = last_name
        self.nic_number = nic_number
        self.email = email
        self.password = password
        self.salt = salt


class UserSchema(ma.Schema):
    # user schema
    class Meta:
        fields = ('id', 'telephone', 'first_name', 'last_name',
                  'nic_number', 'email', 'password', 'salt')

class UserLimitedSchema(ma.Schema):
    # user limited schema
    # returns everything except password and salt of a user
    class Meta:
        fields = ('id', 'telephone', 'first_name', 'last_name',
                  'nic_number', 'email')

# init schema
user_schema = UserSchema()
users_schema = UserSchema(many=True)
user_limited_schema = UserLimitedSchema()
users_limited_schema = UserLimitedSchema(many=True)
