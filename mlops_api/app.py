import os

from flask import Flask

import mlops_api.routes as routes

def create_app() -> Flask:
    app = Flask(__name__)

    routes.add_routes(app)

    return app


app = create_app()

SECRET_KEY = os.urandom(32)
app.config['SECRET_KEY'] = SECRET_KEY
