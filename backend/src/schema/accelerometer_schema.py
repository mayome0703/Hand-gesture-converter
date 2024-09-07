from src.model.accelerometer import Accelerometer
from src import ma


class AccelerometerSchema(ma.SQLAlchemyAutoSchema):
    class Meta:
        model = Accelerometer


accelerometer_schema = AccelerometerSchema()
accelerometers_schema = AccelerometerSchema(many=True)
