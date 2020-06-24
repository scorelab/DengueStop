from database import db
from database import ma
from sqlalchemy import ForeignKeyConstraint

class Alert(db.Model):
    # class corresponding to the alert table in the database
    __tablename__ = 'alert'
    __table_args__ = (
            ForeignKeyConstraint(['org_id'], ['org_unit.id']),
            ForeignKeyConstraint(['creator_id'], ['admin.id']),
            )
    id = db.Column(db.Integer, primary_key=True)
    timestamp = db.Column(db.DateTime, nullable=False)
    alert_type = db.Column(db.String(45), nullable=False)
    subject = db.Column(db.String(45), nullable=False)
    description = db.Column(db.String(500), nullable=False)
    org_id = db.Column(db.Integer, nullable=False)
    creator_id = db.Column(db.Integer, nullable=False)

    def __init__(self, timestamp, alert_type, subject, description, org_id, creator_id):
        self.timestamp = timestamp
        self.alert_type = alert_type
        self.subject = subject
        self.description = description
        self.org_id = org_id
        self.creator_id = creator_id


class AlertSchema(ma.Schema):
    class Meta:
        fields = ('id', 'timestamp', 'alert_type', 'subject',
                  'description', 'org_id', 'creator_id')


# init schema
alert_schema = AlertSchema()
alerts_schema = AlertSchema(many=True)
