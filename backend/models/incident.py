from backend.init import db
from datetime import datetime


class Incident(db.model):
    # class corresponding to the incident table in the database
    id = db.Column(db.Integer, primary_key=True)
    province = db.Column(db.String(45), nullable=False)
    district = db.Column(db.String(45), nullable=False)
    city = db.Column(db.String(45), nullable=False)
    location_lat = db.Column(db.Float, nullable=True)
    location_long = db.Column(db.Float, nullable=True)
    patient_name = db.Column(db.String(45), nullable=False)
    # stores the gender ID
    patient_gender = city = db.Column(db.Integer, nullable=False)
    patient_dob = db.Column(db.DateTime, nullable=False)
    description = city = db.Column(db.String(200), nullable=True)
    # reported time will automatically assign at the time of creation
    reported_time = db.Column(db.DateTime, default=datetime.now)
    reported_user_id = db.Column(db.Integer, nullable=False)
    # patient status is is set to 0 which corresponds to that the patient is pending treatment by default
    patient_status_id = db.Column(db.Integer, nullable=False, default=0)
    # by default incident is not verified and is set to False until verified by the admin
    is_verified = db.Column(db.Boolean, nullable=False, default=False)
    # verified user ID is set to zero to indicate no admin have verified the incident yet
    verified_by = db.Column(db.Integer, nullable=False, default=0)
    # must set the org id checking the province and district
    org_id = db.Column(db.Integer, nullable=False)
