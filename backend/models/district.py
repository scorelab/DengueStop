from database import db
from database import ma
from sqlalchemy import ForeignKeyConstraint

class District(db.Model):
    # class corresponding to the district table in the database
    __tablename__ = 'district'
    __table_args__ = (
            ForeignKeyConstraint(['province_id'], ['province.id']),
            )
    id = db.Column(db.Integer, primary_key=True)
    province_id = db.Column(db.Integer, nullable=False)
    name = db.Column(db.String(45), unique=True, nullable=False)

    def __init__(self, province_id, name):
        self.province_id = province_id
        self.name = name

    def prePopulateDistrict():
        # add record for districts along with IDs
        # change here to edit districts that you require in the application
        # use the api endpoint to write these data to the database AFTER flask-migrate db migration
        objects = [
            # central province
            District(1, 'Kandy'),
            District(1, 'Matale'),
            District(1, 'Nuwara Eliya'),
            # eastern province
            District(2, 'Ampara'),
            District(2, 'Batticaloa'),
            District(2, 'Trincomalee'),
            # north central province
            District(3, 'Anuradhapura'),
            District(3, 'Polonnaruwa'),
            # nothern province
            District(4, 'Jaffna'),
            District(4, 'Kilinochchi'),
            District(4, 'Mannar'),
            District(4, 'Mullaitivu'),
            District(4, 'Vavuniya'),
            # north western province
            District(5, 'Kurunegala'),
            District(5, 'Puttalam'),
            # sabaragamuwa province
            District(6, 'Kegalle'),
            District(6, 'Ratnapura'),
            # southern province
            District(7, 'Galle'),
            District(7, 'Hambantota'),
            District(7, 'Matara'),
            # uva province
            District(8, 'Badulla'),
            District(8, 'Moneragala'),
            # western province
            District(9, 'Colombo'),
            District(9, 'Gampaha'),
            District(9, 'Kalutara'),
        ]
        # bulk insert operation
        db.session.bulk_save_objects(objects)
        db.session.commit()
        

class DistrictSchema(ma.Schema):
    class Meta:
        fields = ('id', 'province_id', 'name')


# init schema
district_schema = DistrictSchema()
districts_schema = DistrictSchema(many=True)
