from flask import Flask, request, render_template
from flask_wtf import FlaskForm, csrf
from wtforms import IntegerField, SubmitField
from wtforms.validators import DataRequired, NumberRange

from mlops_api import model

class PreditionForm(FlaskForm):
    year = IntegerField('Year',[DataRequired(),NumberRange(min=2000,max=3000,message=('Please enter a sensible year'))])

def add_routes(app: Flask):
    @app.route("/", methods=['GET','POST'])
    def home():
        form = PreditionForm()
        csrf.generate_csrf()
        prediction = None
        if request.method == 'POST' and form.validate():        
            year = form.year.data
            prediction = model.predict(year)
        return render_template("home.html", prediction=prediction, form=form)
        

    @app.route("/predict")
    def predict():
        year = request.json["Year"]
        if not isinstance(year, int):
            return "Year must be an integer", 404   
        return {"prediction": model.predict(year)}
