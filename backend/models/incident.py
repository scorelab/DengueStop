from datetime import datetime
from flask_sqlalchemy import SQLAlchemy
from flask_marshmallow import Marshmallow
db = SQLAlchemy()
ma = Marshmallow()


class Incident(db.Model):
    # class corresponding to the Incident Table in the database
    id = db.Column(db.Integer, primary_key=True)
    province = db.Column(db.String(45), nullable=False)
    district = db.Column(db.String(45), nullable=False)
    city = db.Column(db.String(45), nullable=False)
    location_lat = db.Column(db.Float, nullable=True)
    location_long = db.Column(db.Float, nullable=True)
    patient_name = db.Column(db.String(45), nullable=False)
    # stores the gender ID
    patient_gender = db.Column(db.Integer, nullable=False)
    patient_dob = db.Column(db.DateTime, nullable=False)
    description = db.Column(db.String(200), nullable=True)
    # reported time will automatically assign at the time of creation
    reported_time = db.Column(db.DateTime, default=datetime.now)
    reported_user_id = db.Column(db.Integer, nullable=False)
    # patient status is is set to 0 which corresponds to that the patient is pending treatment by default
    patient_status_id = db.Column(db.Integer, nullable=False, default=0)
    # by default incident is not verified and is set to False until verified by the admin
    is_verified = db.Column(db.Integer, nullable=False, default=0)
    verified_by = db.Column(db.Integer, nullable=True)
    # must set the org id checking the province and district
    org_id = db.Column(db.Integer, nullable=False)

    def __init__(self, province, district, city, location_lat, location_long, patient_name, patient_gender, patient_dob, description, reported_user_id, patient_status_id, is_verified, verified_by, org_id):
        self.province = province
        self.district = district
        self.city = city
        self.location_lat = location_lat
        self.location_long = location_long
        self.patient_name = patient_name
        self.patient_gender = patient_gender
        self.patient_dob = patient_dob
        self.description = description
        self.reported_user_id = reported_user_id
        self.patient_status_id = patient_status_id
        self.is_verified = is_verified
        self.verified_by = verified_by
        self.org_id = org_id


class IncidentSchema(ma.Schema):
    class Meta:
        fields = ('id', 'province', 'district', 'city', 'location_lat', 'location_long', 'patient_name', 'patient_gender', 'patient_dob',
                  'description', 'reported_time', 'reported_user_id', 'patient_status_id', 'is_verified', 'verified_by', 'org_id')


# init schema
incident_schema = IncidentSchema()
incidents_schema = IncidentSchema(many=True)
