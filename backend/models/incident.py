from datetime import datetime
from database import db
from database import ma
from sqlalchemy import ForeignKeyConstraint
from models.user import User, user_limited_schema
from models.admin import Admin, admin_limited_schema
from models.patient_status import PatientStatus, patient_status_schema


class Incident(db.Model):
    # class corresponding to the Incident Table in the database
    __tablename__ = 'incident'
    __table_args__ = (
            ForeignKeyConstraint(['reported_user_id'], ['user.id']),
            ForeignKeyConstraint(['patient_status_id'], ['patient_status.id']),
            ForeignKeyConstraint(['org_id'], ['org_unit.id']),
            ForeignKeyConstraint(['verified_by'], ['admin.id']),
            )
    id = db.Column(db.Integer, primary_key=True)
    province = db.Column(db.String(45), nullable=False)
    district = db.Column(db.String(45), nullable=False)
    city = db.Column(db.String(45), nullable=False)
    location_lat = db.Column(db.Float, nullable=True)
    location_long = db.Column(db.Float, nullable=True)
    patient_name = db.Column(db.String(45), nullable=False)
    # stores the gender ID
    patient_gender = db.Column(db.String(1), nullable=False)
    patient_dob = db.Column(db.DateTime, nullable=False)
    description = db.Column(db.String(200), nullable=True)
    # reported time will automatically assign at the time of creation
    reported_time = db.Column(db.DateTime, nullable=False, default=datetime.now)
    reported_user_id = db.Column(db.Integer, nullable=False)
    # patient status is is set to 1 which corresponds to that the patient is pending treatment by default
    patient_status_id = db.Column(db.Integer, nullable=False, default=1)
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

class IncidentWithUserSchema(ma.Schema):
    incident = ma.Nested(incident_schema)
    user = ma.Nested(user_limited_schema)
    status = ma.Nested(patient_status_schema)
    admin = ma.Nested(admin_limited_schema)



incident_with_user_schema = IncidentWithUserSchema()
incidents_with_user_schema = IncidentWithUserSchema(many=True)