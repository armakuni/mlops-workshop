from flask import Flask, request

from mlops_api import model

def add_routes(app: Flask):
    @app.route("/")
    def hello():
        return "Hello, World!"

    @app.route("/predict")
    def predict():
        year = request.json["Year"]     
        return {"prediction": model.predict(year)}
