from src import create_app

app = create_app('development')

# @app.route('/')
# def hello_world():  # put application's code here
#     return 'Hello World!'
from src.controller.sign_parameters_controller import *

if __name__ == '__main__':
    app.run()
