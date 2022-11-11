from datetime import datetime
import logging
import os

import pandas as pd
from sklearn.metrics import mean_absolute_percentage_error
from sklearn.model_selection import train_test_split
from statsmodels.tsa.ar_model import AutoReg

logging.getLogger().setLevel(logging.DEBUG)

# read in the data
df = pd.read_csv("data/processed/cleaned.csv", index_col='Year')

# split the data into train and test
y_train, y_test = train_test_split(df, shuffle=False)

# create the model
model_ag = AutoReg(endog = y_train, \
                   lags = 1, \
                   trend='c', \
                   seasonal = False, \
                   exog = None, \
                   hold_back = None, \
                   period = None, \
                   missing = 'none')

# train the model
fit_ag = model_ag.fit()

# make a predictions and evaluate scores
y_pred = fit_ag.predict(start=y_test.index[0], \
                        end=y_test.index[-1], \
                        dynamic=False)

score = mean_absolute_percentage_error(y_test, y_pred)
print(f"Mean absolute percentage error = {score}")

# save the model
model_path = "models/model.pkl"
dir = os.path.dirname(model_path)
if not os.path.exists(dir):
    os.mkdir(dir)
fit_ag.save(model_path)
