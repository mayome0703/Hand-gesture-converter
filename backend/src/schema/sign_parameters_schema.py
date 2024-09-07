from src.model.sign_parameters import SignParameters
from src import ma
from src.schema.flex_sensor_schema import flex_sensors_schema
from src.schema.accelerometer_schema import accelerometers_schema


class SignParametersSchema(ma.SQLAlchemyAutoSchema):
    class Meta:
        model = SignParameters
        include_fk = True

    flex_sensors = ma.Nested(flex_sensors_schema, many=True)
    accelerometers = ma.Nested(accelerometers_schema, many=True)


sign_parameters_schema = SignParametersSchema()
sign_parameters_schemas = SignParametersSchema(many=True)
