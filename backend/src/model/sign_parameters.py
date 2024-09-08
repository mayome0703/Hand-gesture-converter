from src import db


class SignParameters(db.Model):
    id = db.Column(db.Integer, primary_key=True, unique=True, nullable=False)
    sign = db.Column(db.String, nullable=False, unique=True)

    flex_sensors = db.relationship('FlexSensor', back_populates='sign_parameter')

    accelerometers = db.relationship('Accelerometer', back_populates='sign_parameter')

    def __init__(self, sign):
        self.sign = sign

    def __str__(self):
        return f'{{\nsign: {self.sign},\nflex_sensors: {self.flex_sensors}\naccelerometers: {self.accelerometers}}}'
