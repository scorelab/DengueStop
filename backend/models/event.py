from database import db
from database import ma
from sqlalchemy import ForeignKeyConstraint
from models.admin import Admin, admin_limited_schema
from models.event_status import EventStatus, event_status_schema
from models.org_unit import org_unit_schema

class Event(db.Model):
    # class corresponding to the event table in the database
    __tablename__ = 'event'
    __table_args__ = (
            ForeignKeyConstraint(['status_id'], ['event_status.id']),
            ForeignKeyConstraint(['org_id'], ['org_unit.id']),
            ForeignKeyConstraint(['created_by'], ['admin.id']),
            )
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(45), nullable=False)
    venue = db.Column(db.String(45), nullable=False)
    location_lat = db.Column(db.Float, nullable=False)
    location_long = db.Column(db.Float, nullable=False)
    date_created = db.Column(db.DateTime, nullable=False)
    start_time = db.Column(db.DateTime, nullable=False)
    duration = db.Column(db.Float, nullable=False)
    coordinator_name = db.Column(db.String(45), nullable=False)
    coordinator_contact = db.Column(db.Integer, nullable=False)
    status_id = db.Column(db.Integer, nullable=False)
    org_id = db.Column(db.Integer, nullable=False)
    created_by = db.Column(db.Integer, nullable=False)
    description = db.Column(db.String(500), nullable=False)

    def __init__(self, name, venue, location_lat, location_long, date_created, start_time, duration, coordinator_name, coordinator_contact, status_id, org_id, description):
        self.name = name
        self.venue = venue
        self.location_lat = location_lat
        self.location_long = location_long
        self.date_created = date_created
        self.start_time = start_time
        self.duration = duration
        self.coordinator_name = coordinator_name
        self.coordinator_contact = coordinator_contact
        self.status_id = status_id
        self.org_id = org_id
        self.description = description


class EventSchema(ma.Schema):
    class Meta:
        fields = ('id', 'name', 'venue', 'location_lat', 'location_long', 'date_created', 'start_time',
                  'duration', 'coordinator_name', 'coordinator_contact', 'status_id', 'org_id', 'description')


# init schema
event_schema = EventSchema()
events_schema = EventSchema(many=True)


class EventFullInfoSchema(ma.Schema):
    event = ma.Nested(event_schema)
    admin = ma.Nested(admin_limited_schema)
    status = ma.Nested(event_status_schema)
    org_unit = ma.Nested(org_unit_schema)



event_with_full_schema = EventFullInfoSchema()
events_with_full_schema = EventFullInfoSchema(many=True)