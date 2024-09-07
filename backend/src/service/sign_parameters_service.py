from src.model.sign_parameters import SignParameters
from src.service.flex_sensor_service import add_flex_sensors
from src.service.accelerometer_service import add_accelerometer
from src import db


def add_sign(sign, flex_sensors, accelerometers):
    new_sign = SignParameters(sign=sign)
    db.session.add(new_sign)
    db.session.commit()

    new_sign = SignParameters.query.filter_by(sign=sign).first()

    add_flex_sensors(flex_sensors, new_sign)
    add_accelerometer(accelerometers, new_sign)

    new_sign = SignParameters.query.filter_by(sign=sign).first()
    return new_sign


