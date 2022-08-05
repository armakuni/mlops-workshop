from flask import Flask

import src.routes as routes


def create_app() -> Flask:
    app = Flask(__name__)

    routes.add_routes(app)

    return app


app = create_app()
