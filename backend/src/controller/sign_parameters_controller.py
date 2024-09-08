from src.app import app
from flask import request, jsonify
from src.service.sign_parameters_service import add_sign, find_sign


@app.route('/sign/add', methods=['POST'])
def sign_add():
    sign = request.json['sign']
    flex_sensors = request.json['flex_sensors']
    accelerometers = request.json['accelerometers']

    response = add_sign(sign, flex_sensors, accelerometers)
    return response


@app.route('/sign/get', methods=['POST'])
def sign_get():
    flex_sensors = request.json['flex_sensors']
    accelerometers = request.json['accelerometers']
    response = find_sign(flex_sensors, accelerometers)

    return response
