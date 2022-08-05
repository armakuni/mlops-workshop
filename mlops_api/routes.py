from flask import Flask


def add_routes(app: Flask):
    @app.route("/")
    def hello():
        return "Hello, World!"
