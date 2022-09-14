import pandas as pd

from mlwrap import io

cache = dict()

MODEL = 'model'

def get_model():
    if MODEL not in cache:
        cache[MODEL] = io.load_model("data/model.pkl")
    return cache[MODEL]


def predict(year: int) -> list:
    model = get_model()
    df = pd.DataFrame(data={'Year' : [year]})
    prediction = model.predict(df)
    return prediction[0]
