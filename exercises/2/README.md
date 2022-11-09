# Exercise 2

## Introduction

The data and models won't always be small so checking them into your repo isn't a great idea.

We will now use DVC to check artefacts into an S3

Here's a summary of what we will cover:
- save data and model artefacts to S3 using the DVC tool (which effectively makes our git repo a data/model registry)

## Remote storage of processed data and model

DVC is used to allow a pointer file to be checked in to the repo and artefacts to be pushed to cloud storage. 

To set up DVC, we need an s3 bucket. For convencience, we can use the remote state bucket from our terraform deployment, so jump ahead a little and run `make tf-bootstrap-apply` - see the Deployment section for more details.

When you get to the point of updating the data file (data/processed/cleaned.csv) or the model file (models/model.pkl) we need to run `make dvc-remove` to remove the pointer file. Note that the data folder is in the .gitignore. The process for updating data/model therefore goes as:
- remove .dvc pointer file
- make changes
- create new .dvc file by re-adding the files to dvc
- push files to remote storage
- commit pointer file to git repo

Once you have made your changes to the files in the data folder, type `make dvc-push` to add the new pointer file to git and push it to remote storage.

Note that DVC can silently fail if you don't have valid AWS credentials, so beware.