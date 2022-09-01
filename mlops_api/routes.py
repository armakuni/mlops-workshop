from flask import Flask, request, render_template

from mlops_api import model

def add_routes(app: Flask):
    @app.route("/")
    def home():
        return render_template("home.html")

    @app.route("/predict")
    def predict():
        year = request.json["Year"]     
        return {"prediction": model.predict(year)}
