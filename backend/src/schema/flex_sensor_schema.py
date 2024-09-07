from src.model.flex_sensor import FlexSensor
from src import ma


class FlexSensorSchema(ma.SQLAlchemyAutoSchema):
    class Meta:
        model = FlexSensor


flex_sensor_schema = FlexSensorSchema()
flex_sensors_schema = FlexSensorSchema(many=True)
