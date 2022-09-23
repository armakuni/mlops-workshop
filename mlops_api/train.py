import logging
import pandas as pd

from mlwrap import io, runners, scores
from mlwrap.config import MLConfig
from mlwrap.enums import ProblemType

logging.getLogger().setLevel(logging.DEBUG)

# read in the data
df = pd.read_csv("data/cleaned.csv")

# set up the config object
config = MLConfig(
            model_feature_id="Total",
            problem_type=ProblemType.Regression
        )

# train the model
results = runners.train(config, df)

# save the model
io.save_model(results.model, "data/model.pkl")
