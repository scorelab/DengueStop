from database import db
from database import ma


class OrgUnit(db.Model):
    # class corresponding to the org_unit Table in the database
    __tablename__ = 'org_unit'
    id = db.Column(db.Integer, primary_key=True)
    province = db.Column(db.String(45), nullable=False)
    district = db.Column(db.String(45), nullable=False)
    name = db.Column(db.String(45), nullable=False)
    contact = db.Column(db.String(10), nullable=False)

    def __init__(self, province, district, name, contact):
        self.province = province
        self.district = district
        self.name = name
        self.contact = contact
    
    def prePopulateOrgUnit():
        # ONLY FOR TESTING PURPOSES
        # adds a dummy org_unit with ID 1 to surpress foreign_key errors
        objects = [
            # status 1
            OrgUnit('Western', 'Colombo', 'National Hosptal of Sri Lanka', '0112691111')
        ]
        # bulk insert operation
        db.session.bulk_save_objects(objects)
        db.session.commit()


class OrgUnitSchema(ma.Schema):
    class Meta:
        fields = ('id', 'province', 'district', 'name', 'contact')


# init schema
org_unit_schema = OrgUnitSchema()
org_units_schema = OrgUnitSchema(many=True)
