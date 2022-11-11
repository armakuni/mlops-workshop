import pandas as pd

# read in the data
df = pd.read_csv("data/processed/cleaned.csv", index_col='Year')

# train the model
# ADD YOUR CODE HERE

# save the model
model_path = "models/model.pkl"
