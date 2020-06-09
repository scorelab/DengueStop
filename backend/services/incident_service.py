from models.incident import Incident


def get_all_incidents(provice, district):
    return Incident.query.all()


def get_one_incident(id):
    return Incident.query.filter_by(id=id).first()
