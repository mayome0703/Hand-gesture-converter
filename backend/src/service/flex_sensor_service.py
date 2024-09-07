from src.model.flex_sensor import FlexSensor
from src import db


def add_flex_sensors(flex_sensors, sign):
    new_flex_sensors = [FlexSensor(
        flex_min=flex["flex_min"],
        flex_max=flex["flex_max"],
        sign_parameter=sign
    ) for flex in flex_sensors]

    db.session.add_all(new_flex_sensors)
    db.session.commit()
