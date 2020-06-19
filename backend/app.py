from models.user import User, user_schema, users_schema
from models.incident import Incident, incident_schema, incidents_schema
from flask import Flask, request, jsonify, make_response
from flask_sqlalchemy import SQLAlchemy
from flask_marshmallow import Marshmallow
import jwt
import datetime
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
        salt = request.json['salt']
        new_user = User(telephone, first_name, last_name,
                        nic_number, email, password, salt)
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


@app.route('/update_user', methods=['POST'])
def update_user():
    try:
        user_id = request.json['id']
        first_name = request.json['firstName']
        last_name = request.json['lastName']
        nic_number = request.json['nicNumber']
        email = request.json['email']
        updated_user = User.query.filter_by(id=user_id).first()
        updated_user.first_name = first_name
        updated_user.last_name = last_name
        updated_user.nic_number = nic_number
        updated_user.email = email
        db.session.merge(updated_user)
        db.session.commit()
        return user_schema.jsonify(updated_user)

    except IOError:
        print("I/O error")
    except ValueError:
        print("Value Error")
    except:
        print("Unexpected error")
        raise


@app.route('/login_user', methods=['POST'])
def login_user():
    try:
        username = request.json['username']
        password = request.json['password']
        # selecting data without the password and salt as they are not required for the user session
        current_user = User.query.filter_by(telephone=username).first()
        db.session.commit()
        result = user_schema.dump(current_user)
        if(result != {}):
            # checking whether the hashed password matches the database
            if(password == result['password']):
                # returning a jwt to the app
                # using the REVERSED salt as the secret key
                secret_key = result['salt'][::-1]
                token = jwt.encode({'user': username, 'exp': datetime.datetime.utcnow(
                ) + datetime.timedelta(minutes=30)}, secret_key)
                userData = {'id': result['id'], 'first_name': result['first_name'], 'last_name': result['last_name'],
                            'email': result['email'], 'telephone': result['telephone'], 'nic_number': result['nic_number']}
                return jsonify({'token': token.decode('UTF-8'), 'userData': userData})
        # returning 401 error to the app
        return make_response('Could Not Authenticate', 401)

    except IOError:
        print("I/O error")
    except ValueError:
        print("Value Error")
    except:
        print("Unexpected error")
        raise


@ app.route('/get_user_salt', methods=['POST'])
def get_user_salt():
    # user will get their salt to generate the hash required to the provided password
    try:
        username = request.json['username']
        user_hash = User.query.with_entities(User.salt).filter_by(
            telephone=username).first()
        db.session.commit()
        result = user_schema.dump(user_hash)
        if(result != {}):
            return jsonify(result)
        return make_response('User Not Found', 404)

    except IOError:
        print("I/O error")
    except ValueError:
        print("Value Error")
    except:
        print("Unexpected error")
        raise


@ app.route('/get_incidents_by_user/<int:user_id>', methods=['GET'])
def get_incidents_by_user(user_id):
    # returns all the incidents that was reported by the user of the user_id
    incidents = Incident.query.filter_by(
        reported_user_id=user_id).order_by(Incident.reported_time.desc()).all()
    db.session.commit()
    result = incidents_schema.dump(incidents)
    return jsonify(result)


# running server
if __name__ == '__main__':
    app.run(debug=True)
