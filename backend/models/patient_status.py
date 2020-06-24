from database import db
from database import ma


class PatientStatus(db.Model):
    # class corresponding to the patient status Table in the database
    __tablename__ = 'patient_status'
    id = db.Column(db.Integer, primary_key=True)
    status = db.Column(db.String(45), unique=True, nullable=False)

    def __init__(self, status):
        self.status = status

    def prePopulatePatientStatus():
        # add record for patient statuses along with IDs
        # change here to edit patient statuses that you require in the application
        # use the api endpoint to write these data to the database AFTER flask-migrate db migration
        objects = [
            # status 1
            PatientStatus('Pending Verification'),
            # status 2
            PatientStatus('Pending Treatment'),
            # status 3
            PatientStatus('Under Treatment'),
            # status 4
            PatientStatus('Recovering'),
            # status 5
            PatientStatus('Recovered'),
            # status 6
            PatientStatus('Death'),
            # status 7
            # this occurs when the incident reported is declined by the admins
            PatientStatus('Declined'),
        ]
        # bulk insert operation
        db.session.bulk_save_objects(objects)
        db.session.commit()
        

class PatientStatusSchema(ma.Schema):
    class Meta:
        fields = ('id', 'status')


# init schema
patient_status_schema = PatientStatusSchema()
patient_statuses_schema = PatientStatusSchema(many=True)
