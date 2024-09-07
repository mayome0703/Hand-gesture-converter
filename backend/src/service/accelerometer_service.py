from src.model.accelerometer import Accelerometer
from src import db


def add_accelerometer(accelerometers, sign):
    new_acc = [Accelerometer(
        acc_min=acc["acc_min"],
        acc_max=acc["acc_max"],
        sign_parameter=sign
    ) for acc in accelerometers]

    db.session.add_all(new_acc)
    db.session.commit()
