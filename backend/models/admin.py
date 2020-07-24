from sqlalchemy import ForeignKeyConstraint
from database import db
from database import ma


class Admin(db.Model):
    # class corresponding to the admin table in the database
    __tablename__ = 'admin'
    __table_args__ = (
            ForeignKeyConstraint(['org_id'], ['org_unit.id']),
            )
    id = db.Column(db.Integer, primary_key=True)
    email = db.Column(db.String(45), unique=True, nullable=False)
    name = db.Column(db.String(45), nullable=False)
    contact = db.Column(db.String(10), nullable=False)
    password = db.Column(db.String(45), nullable=False)
    salt = db.Column(db.String(45), nullable=False)
    org_id = db.Column(db.Integer, nullable=False)

    def __init__(self, email, name, contact, password, salt, org_id):
        self.email = email
        self.name = name
        self.contact = contact
        self.password = password
        self.salt = salt
        self.org_id = org_id
    
    def prePopulateAdminUser():
        # ONLY FOR TESTING PURPOSES
        # adds a dummy admin with ID 1 to surpress foreign_key errors
        objects = [
            Admin('admin@dengue.com', 'Admin User', '0777123123', 'test1234', 'test1234', 1)
        ]
        # bulk insert operation
        db.session.bulk_save_objects(objects)
        db.session.commit()



class AdminSchema(ma.Schema):
    # Admin schema
    class Meta:
        fields = ('id', 'email', 'name', 'contact',
                  'password', 'salt', 'org_id')

class AdminLimitedSchema(ma.Schema):
    # admin limited schema
    # returns everything except password and salt of a admin
    class Meta:
        fields = ('id', 'email', 'name', 'contact')

# init schema
admin_schema = AdminSchema()
admins_schema = AdminSchema(many=True)
admin_limited_schema = AdminLimitedSchema()
admins_limited_schema = AdminLimitedSchema(many=True)