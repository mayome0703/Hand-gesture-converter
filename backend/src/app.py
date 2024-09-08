from src import create_app

app = create_app('development')

from src.controller.sign_parameters_controller import *

if __name__ == '__main__':
    app.run()
