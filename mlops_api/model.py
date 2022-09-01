import os
import pandas as pd

from mlwrap import io, runners
from mlwrap.config import Feature, InputData, MLConfig
from mlwrap.enums import AlgorithmType, DataType, FeatureType

cache = dict()

MODEL = 'model'
ENCODER = 'encoder'

features = { 
        "Year" : Feature(id = "Year", feature_type=FeatureType.Continuous),
        "Total" : Feature(id = "Total", feature_type=FeatureType.Continuous)
    }

def get_model():
    if MODEL not in cache:
        cache[MODEL] = io.load_pkl("models/model.pkl")
    return cache[MODEL]

def get_encoder():
    if ENCODER not in cache:
        cache[ENCODER] = io.load_pkl("models/encoder.pkl")
    return cache[ENCODER]

def predict(year: int) -> list:
    df = pd.DataFrame(data={'Year':[year]})
    config = MLConfig(
            algorithm_type=AlgorithmType.SklearnLinearModel,
            features=features,
            model_feature_id="Total",
            input_data=InputData(data_type=DataType.DataFrame, data_frame=df),
            model_bytes=get_model(),
            encoder_bytes=get_encoder()
        )
    results = runners.infer(config)
    prediction = results.inference_results[0].values[0]
    return prediction
