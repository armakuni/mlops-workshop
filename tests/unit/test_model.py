import pandas as pd

from mlops_api import model

def test_get_model():
    m = model.get_model()
    assert m is not None

def test_predict():
    p = model.predict(2030)
    assert p is not None
    assert p > 0
