# Serverless CI/CD with safedeployments, as code.

:fr: Sommaire / :gb: Table of Contents
=================

<!--ts-->

- [:fr: Description du projet](#fr-description-du-projet)
- [:gb: Project Description](#gb-project-description)
  
---

# :fr: Description du projet

Ce projet sert de support à l'article de blog suivant: 
[joseph-mbimbi.fr/blog/aws-serverless-cicd-demo-1](joseph-mbimbi.fr/blog/aws-serverless-cicd-demo-1)

## Déploiement de la pipeline

créer la stack de la pipeline `CloudFormation`: `aws cloudformation create-stack --stack-name serverless-cicd-pipeline-stack --template-body file://pipeline-stack.yml --parameters ParameterKey=ApplicationName,ParameterValue=serverless-cicd --capabilities CAPABILITY_NAMED_IAM`

mettre à jour la stack de la pipeline `CloudFormation`: `aws cloudformation update-stack --stack-name serverless-cicd-pipeline-stack --template-body file://pipeline-stack.yml --capabilities CAPABILITY_NAMED_IAM`

### Déploiement de l'application (via SAM)

1. En 3 temps

```shell
mvn clean package
sam package --template-file sam-template.yml --s3-bucket $BUCKET --output-template-file out-sam-template.yml
sam deploy --template-file out-sam-template.yml --stack-name serverless-cicd-demo-application --no-confirm-changeset --capabilities CAPABILITY_IAM
```

2. En 2 temps

```shell
mvn clean package
sam deploy --template-file sam-template.yml --stack-name serverless-cicd-application-stack --capabilities CAPABILITY_IAM --no-confirm-changeset --s3-bucket $BUCKET
```

# :gb: Project Description

This project is a support for the following blog article 
[joseph-mbimbi.fr/blog/aws-serverless-cicd-demo-1](joseph-mbimbi.fr/blog/aws-serverless-cicd-demo-1) 
(blog article only in french for the moment)

## pipeline deployment

create `CloudFormation` pipeline stack: `aws cloudformation create-stack --stack-name serverless-cicd-pipeline-stack --template-body file://pipeline-stack.yml --parameters ParameterKey=ApplicationName,ParameterValue=serverless-cicd --capabilities CAPABILITY_NAMED_IAM`

update `CloudFormation` pipeline stack: `aws cloudformation update-stack --stack-name serverless-cicd-pipeline-stack --template-body file://pipeline-stack.yml --capabilities CAPABILITY_NAMED_IAM`

### application deployment (via SAM)

In 3 passes:

```shell
mvn clean package
sam package --template-file sam-template.yml --s3-bucket $BUCKET --output-template-file out-sam-template.yml
sam deploy --template-file out-sam-template.yml --stack-name serverless-cicd-demo-application --no-confirm-changeset --capabilities CAPABILITY_IAM
```

2. In 2 passes

```shell
mvn clean package
sam deploy --template-file sam-template.yml --stack-name serverless-cicd-application-stack --capabilities CAPABILITY_IAM --no-confirm-changeset --s3-bucket $BUCKET
```