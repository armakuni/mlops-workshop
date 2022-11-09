# Exercise 1

## Introduction

For this exercise we will aim to build a full MLOps pipeline from data processing through model training and ending with a predictor deployed to the cloud.

Here's a summary of what we will cover:
- write a data processing script
- write a model training script
- implement code in the Flask app to use the model and get the tests passing - note that the smoke test will fail so don't worry about that
- Write a CI script (GitHub Action) that:
    - runs the data prep script
    - runs the model training script
    - runs the unit tests
    - deploys the model in a Flask app to AWS Beanstalk. Don't worry, the terraform is provided, you just need to write a github action to bring it all together
    - stretched target: run a smoke test against the deployed app - the test is already written, you just need to implement it in your CI script

In the following sections there are more details on the steps to complete. If you get stuck, or like to cheat, there's answers in the exercise1 branch.

## Run the notebook

First things first, make sure you've set up your virtual environment and run through the exploratory notebook (notebooks/eda.ipynb). 

(Hint: the code you need to make the data processing and model training scripts is in this notebook.)

## Data processing

To convert the data, write a data prep script. I'd recommend calling this `src/train.py`. This should create a file called `data/processed/cleaned.csv` which we can use to train an ML model.

We don't want to check the file directly into git, instead we're going to use DVC to push the file to remote storage. For more details on this see the instructions in the "Remote storage of processed data and model" section of the main readme.

## Model training

To train the model, write a model training script that reads in the processed data file (we can hard code the file name to ). The output is written to `models/model.pkl`.

As with the processed data, we'll use DVC to check in the file To update the trained model in remote storage, see the instructions in the "Remote storage of processed data and model" section.

## Deployment

We'll deploy the app to AWS Elastic Beanstalk. The bulk of the code is provided for this.

The keen-eyed will notice that we are going to use terragrunt so there are some extra hcl files dotted around that you wouldn't normally have with vanilla terraform.

To get started, we need to create the remote state bucket and an application IAM user via. Steps for this are:
- make sure you've logged in to AWS - see details in the main readme
- in `terraform/terragrunt.hcl`, edit the `owner` and `remote_state_name` variables in the `locals` block towards the top of the file
- then run `make tf-bootstrap-apply`

The bootstrapping will create an IAM user that we can run the CI as. If you peek at the GitHub action in ci.yml you'll see that we need to define two secrets for the CI script to work: AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY. At the time of writing the terraform doesn't output these so the easiest thing to do is log into the AWS console and generate a new access key, then copy down the key id and secret. Then log into GitHub and add these as repository secrets by going to Settings -> Secrets -> Actions -> then click on the "New repository secret" button.

Once that has ran, we could deploy the app manually using `make tf-app-apply` but we can be cooler than that. So, alternatively, for continuous deployment, the repo can be hooked up to a Github Action to run unit tests and deploy the Flask app to AWS Beanstalk. See the ci.yml file for further details - this may not get cloned if you fork the repo so refer back to the source if it's missing.

Your goal is to fill in the missing line in the 'Terragrunt apply' step. To explain what's going on here, we zip up the repo code early on in the CI script as that is what we will pass to AWS, then when the Beanstalk app is deployed AWS uses the Dockerfile and builds an image. We need to set the `COMMIT_ID` environment variable in this step so that the terraform code can pick it up and work out the file name of the zip.

(Hint: it's the same command you would use to manually deploy the app.)

Once the app has deployed, you should be able to see the url in the terraform output.

You can then browse to the app and make a prediction using the UI.

## Reflection

In this exercise we've bundled everything in one repo and one CI script. What are the pro's and con's to doing this?

## Stretched target: Smoke test the app

If you don't have time for this then skip on. Otherwise, as a stretched target, we can use the smoke test in `tests/smoke` to call our endpoint and check that it is working ok.

Hints:
- To get the url of the deployed app you can use `make tf-app-output-cname`
- To run the smoke test you can use `docker run -e API_HOST=$API_HOST mlops-intro pytest tests/smoke`

## Clean-up

Be kind and rewind. By that I mean please destroy any AWS resources that you created:
- To remove the deployment you can manually run `make tf-app-destroy`
- To remove the bootstrap resources, manually run `make tf-bootstrap-destroy`
- To remove the remote state bucket, the easiest thing to do is log on to the AWS console and delete it.