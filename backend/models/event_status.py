from database import db
from database import ma


class EventStatus(db.Model):
    # class corresponding to the event status Table in the database
    __tablename__ = 'event_status'
    id = db.Column(db.Integer, primary_key=True)
    status = db.Column(db.String(45), unique=True, nullable=False)

    def __init__(self, status):
        self.status = status

    def prePopulateEventStatus():
        # add record for event statuses along with IDs
        # change here to edit event statuses that you require in the application
        # use the api endpoint to write these data to the database AFTER flask-migrate db migration
        objects = [
            # status 1
            EventStatus('Pending Event'),
            # status 2
            EventStatus('Upcoming Event'),
            # status 3
            EventStatus('Now Happening'),
            # status 4
            EventStatus('Finished Event'),
            # status 5
            EventStatus('Cancelled Event'),
        ]
        # bulk insert operation
        db.session.bulk_save_objects(objects)
        db.session.commit()


class EventStatusSchema(ma.Schema):
    class Meta:
        fields = ('id', 'status')


# init schema
event_status_schema = EventStatusSchema()
event_statuses_schema = EventStatusSchema(many=True)
