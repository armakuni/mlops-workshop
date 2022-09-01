import json
import os

import pandas as pd

from mlwrap import io, runners
from mlwrap.enums import AlgorithmType, DataType, FeatureType
from mlwrap.config import InputData, MLConfig, Feature


# read in the data
df = pd.read_csv("data/cleaned.csv")

# define the features
features = { 
        "Year" : Feature(id = "Year", feature_type=FeatureType.Continuous),
        "Total" : Feature(id = "Total", feature_type=FeatureType.Continuous)
    }

# set up the config object
config = MLConfig(
            algorithm_type=AlgorithmType.SklearnLinearModel,
            features=features,
            model_feature_id="Total",
            input_data=InputData(data_type=DataType.DataFrame, data_frame=df),
        )

# train the model
results = runners.train(config)

# output the metrics
scores = { k.name: float(v) for k,v in results.scores.items() }
with open("metrics.json", "w") as f:
    json.dump(scores, f)

# save the model and encoders
dirname = 'models'
if not os.path.exists(dirname):
        os.makedirs(dirname)

io.save_pkl(results.model_bytes, "models/model.pkl")
io.save_pkl(results.encoder_bytes, "models/encoder.pkl")
