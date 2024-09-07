from src import db


class FlexSensor(db.Model):
    id = db.Column(db.Integer, primary_key=True, unique=True, nullable=False)
    flex_min = db.Column(db.Float)
    flex_max = db.Column(db.Float)

    sign_parameters_id = db.Column(db.Integer, db.ForeignKey('sign_parameters.id'))
    sign_parameter = db.relationship('SignParameters', back_populates='flex_sensors')

    def __init__(self, flex_min, flex_max, sign_parameter):
        self.flex_min = flex_min
        self.flex_max = flex_max
        self.sign_parameter = sign_parameter
