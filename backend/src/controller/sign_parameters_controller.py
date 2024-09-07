from src.app import app
from flask import request, jsonify

from src.model.sign_parameters import SignParameters
from src.service.sign_parameters_service import add_sign
from src.schema.sign_parameters_schema import sign_parameters_schema, sign_parameters_schemas


@app.route('/sign/add', methods=['POST'])
def sign_add():
    # print(request.json['sign'])
    sign = request.json['sign']
    flex_sensors = request.json['flex_sensors']
    accelerometers = request.json['accelerometers']

    response = add_sign(sign, flex_sensors, accelerometers)
    return sign_parameters_schema.dump(response)


@app.route('/sign/get', methods=['GET'])
def sign_get():
    sign = SignParameters.query.first()
    return sign_parameters_schema.dump(sign)
