import streamlit as st
import pandas as pd
import joblib

from mlops_api import model

# Title
st.header("MLOps API - Predictions for number of vehicle charge points in the US by year")

# Enter year bar
year = st.number_input("Enter Year", 2000, 3000)

# Hide the hamburger and made with streamlit
hide_streamlit_style = """
            <style>
            #MainMenu {visibility: hidden;}
            footer {visibility: hidden;}
            </style>
            """
st.markdown(hide_streamlit_style, unsafe_allow_html=True)

if st.button("Predict", disabled=year is None):
    
    prediction = model.predict(year)
        
    # Output prediction
    st.text(f"The prediction in {year} is {prediction} charge points")