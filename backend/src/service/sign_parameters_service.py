from flask import jsonify
from src.model.sign_parameters import SignParameters
from src.service.flex_sensor_service import add_flex_sensors
from src.service.accelerometer_service import add_accelerometer
from src.schema.sign_parameters_schema import sign_parameters_schema, sign_parameters_schemas
from src import db


def add_sign(sign, flex_sensors, accelerometers):
    new_sign = SignParameters(sign=sign)
    db.session.add(new_sign)
    db.session.commit()

    new_sign = SignParameters.query.filter_by(sign=sign).first()

    add_flex_sensors(flex_sensors, new_sign)
    add_accelerometer(accelerometers, new_sign)

    new_sign = SignParameters.query.filter_by(sign=sign).first()
    return sign_parameters_schema.dump(new_sign)


def find_sign(flex_sensors, accelerometers):
    all_signs = SignParameters.query.all()
    sign = 'No character found'

    for s in all_signs:
        is_true = True
        flex = s.flex_sensors

        for i in range(0, len(flex_sensors)):
            # print(flex[i].flex_min, flex[i].flex_max, flex_sensors[i])
            if not (flex[i].flex_min <= flex_sensors[i] <= flex[i].flex_max):
                is_true = False
                break

        # print(is_true)
        if is_true:
            acc = s.accelerometers

            for i in range(0, len(accelerometers)):
                # print(acc[i].acc_min, acc[i].acc_max, accelerometers[i])
                if not (acc[i].acc_min <= accelerometers[i] <= acc[i].acc_max):
                    is_true = False
                    break

        # print(is_true)
        if is_true:
            sign = s.sign
            break

    return jsonify({"signed_letter": sign})
