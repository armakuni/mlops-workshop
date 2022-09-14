import logging
import pandas as pd

from mlwrap import io, runners, scores
from mlwrap.enums import AlgorithmType, FeatureType
from mlwrap.config import MLConfig, Feature

logging.getLogger().setLevel(logging.DEBUG)

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
        )

# train the model
results = runners.train(config, df)
scores.print_scores(results.scores)

# save the model
io.save_model(results.model, "data/model.pkl")
