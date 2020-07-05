from models.user import User, user_schema, users_schema
from flask import Flask, request, jsonify, make_response
from database import db
from database import ma
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
SECRET_KEY = "thisisasecretkeythatmustbechangedlater"
# init extensions
db.init_app(app)
ma.init_app(app)


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
                secret_key = SECRET_KEY
                token = jwt.encode({'user': username, 'userId': result['id'], 'exp': datetime.datetime.utcnow(
                ) + datetime.timedelta(hours=1)}, secret_key)
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

# running server
if __name__ == '__main__':
    app.run(debug=True)
