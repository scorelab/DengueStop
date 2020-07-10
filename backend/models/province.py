from database import db
from database import ma


class Province(db.Model):
    # class corresponding to the province table in the database
    __tablename__ = 'province'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(45), unique=True, nullable=False)

    def __init__(self, name):
        self.name = name

    def prePopulateProvince():
        # add record for provinces along with IDs
        # change here to edit provinces that you require in the application
        # use the api endpoint to write these data to the database AFTER flask-migrate db migration
        objects = [
            # province 1
            Province('Central'),
            # province 2
            Province('Eastern'),
            # province 3
            Province('North Central'),
            # province 4
            Province('Northern'),
            # province 5
            Province('North Western'),
            # province 6
            Province('Sabaragamuwa'),
            # province 7
            Province('Southern'),
            # province 8
            Province('Uva'),
            # province 9
            Province('Western'),
        ]
        # bulk insert operation
        db.session.bulk_save_objects(objects)
        db.session.commit()
        

class ProvinceSchema(ma.Schema):
    class Meta:
        fields = ('id', 'name')


# init schema
province_schema = ProvinceSchema()
provinces_schema = ProvinceSchema(many=True)
