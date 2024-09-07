from src import db


class Accelerometer(db.Model):
    id = db.Column(db.Integer, primary_key=True, unique=True, nullable=False)
    acc_min = db.Column(db.Float)
    acc_max = db.Column(db.Float)

    sign_parameters_id = db.Column(db.Integer, db.ForeignKey('sign_parameters.id'))
    sign_parameter = db.relationship('SignParameters', back_populates='accelerometers')

    def __init__(self, acc_min, acc_max, sign_parameter):
        self.acc_min = acc_min
        self.acc_max = acc_max
        self.sign_parameter = sign_parameter
