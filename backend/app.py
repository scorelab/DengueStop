from models.user import User, user_schema, users_schema
from models.incident import Incident, incident_schema, incidents_schema
from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_marshmallow import Marshmallow

import os

# init app
app = Flask(__name__)
basedir = os.path.abspath(os.path.dirname(__file__))
# database
# to supress the warning on the terminal, specify this line
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://root:test1234@localhost/dengue_stop'
# init DB
db = SQLAlchemy(app)
# init marshmallow
ma = Marshmallow(app)


@app.route('/', methods=['GET'])
def hello_world():
    return jsonify({'name': 'hello'})


@app.route('/report_incident', methods=['POST'])
# endpoint to add a new report
def report_incident():
    try:
        province = request.json['province']
        district = request.json['district']
        city = request.json['city']
        location_lat = request.json['locationLat']
        location_long = request.json['locationLong']
        patient_name = request.json['patientName']
        patient_gender = request.json['patientGender']
        patient_dob = request.json['patientDob']
        description = request.json['description']
        reported_user_id = request.json['reportedUserId']
        patient_status_id = request.json['patientStatusId']
        is_verified = request.json['isVerified']
        verified_by = request.json['verifiedBy']
        org_id = request.json['orgId']
        new_incident = Incident(province, district, city, location_lat, location_long, patient_name, patient_gender,
                                patient_dob, description, reported_user_id, patient_status_id, is_verified, verified_by, org_id)
        db.session.add(new_incident)
        db.session.commit()
        return incident_schema.jsonify(new_incident)

    except IOError:
        print("I/O error")
    except ValueError:
        print("Value Error")
    except:
        print("Unexpected error")
        raise


@app.route('/create_user', methods=['POST'])
def create_user():
    try:
        telephone = request.json['telephone']
        first_name = request.json['firstName']
        last_name = request.json['lastName']
        nic_number = request.json['nicNumber']
        email = request.json['email']
        password = request.json['password']
        new_user = User(telephone, first_name, last_name,
                        nic_number, email, password)
        db.session.add(new_user)
        db.session.commit()
        return user_schema.jsonify(new_user)

    except IOError:
        print("I/O error")
    except ValueError:
        print("Value Error")
    except:
        print("Unexpected error")
        raise


@app.route('/get_users', methods=['GET'])
def get_users():
    all_users = User.query.all()
    result = users_schema.dump(all_users)
    return jsonify(result)


@app.route('/get_incidents_by_user/<int:user_id>', methods=['GET'])
def get_incidents_by_user(user_id):
    # returns all the incidents that was reported by the user of the user_id
    incidents = Incident.query.filter_by(
        reported_user_id=user_id).order_by(Incident.reported_time.desc()).all()
    result = incidents_schema.dump(incidents)
    return jsonify(result)


# running server
if __name__ == '__main__':
    app.run(debug=True)
