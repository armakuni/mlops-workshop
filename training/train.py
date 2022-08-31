import pickle

import pandas as pd

from mlwrap import runners
from mlwrap.enums import AlgorithmType, DataType, FeatureType
from mlwrap.config import InputData, MLConfig, Feature, TrainingResults


# read in the data
df = pd.read_csv("../data/cleaned.csv")

# define the features
features = { 
        "Year" : Feature(id = "Year", feature_type=FeatureType.Continuous),
        "State" : Feature(id = "State", feature_type=FeatureType.Categorical),
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

# save the model and encoders
pickle.dump(results.model_bytes, open("../models/model.pkl", "wb"))
pickle.dump(results.encoder_bytes, open("../models/encoder.pkl", "wb"))
