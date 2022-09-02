import os

from flask import Flask

import mlops_api.extensions as extensions
import mlops_api.routes as routes

SECRET_KEY = os.urandom(32)

def create_app() -> Flask:
    app = Flask(__name__)

    routes.add_routes(app)

    app.config['SECRET_KEY'] = SECRET_KEY
    extensions.csrf.init_app(app)

    return app

app = create_app()
