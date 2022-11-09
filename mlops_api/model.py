from datetime import datetime

import statsmodels.api as sm

cache = dict()

MODEL = 'model'

def get_model():
    if MODEL not in cache:
        cache[MODEL] = sm.load_pickle("models/model.pkl")
    return cache[MODEL]


def predict(year: int) -> float:
    model = get_model()
    pass
