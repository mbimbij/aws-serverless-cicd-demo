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

1. Créer un compte pour l'environnement de test
2. Créer un compte pour la pipeline
3. Définir les profiles suivants dans `~/.aws/config` et `~/.aws/credentials`
  - profile `operations`: le profile du compte dédié à l'éxécution de la pipeline,
  - profile `test`: le profile du compte faisant office d'environnement de test
4. Vérifier que les profiles sont bien renseignés dans le fichier `pipeline.env`
5. Lancer la création de la pipeline: `./create-pipeline.sh`
6. Activez la connexion github dans compte d'opérations


# :gb: Project Description

This project is a support for the following blog article 
[joseph-mbimbi.fr/blog/aws-serverless-cicd-demo-1](joseph-mbimbi.fr/blog/aws-serverless-cicd-demo-1) 
(blog article only in french for the moment)

## pipeline deployment

1. Create an account that will be used as a test environment
2. Create an account that will be used for pipeline execution
3. Define the following profiles in `~/.aws/config` et `~/.aws/credentials`
  - profile `operations`: dedicated to pipeline execution
  - profile `test`: dedicated to test environment
4. Verify that the profiles are set appropriately in `pipeline.env` file
5. Launch the creation of the pipeline: `./create-pipeline.sh`
6. Activate the github connection in the `operations` account