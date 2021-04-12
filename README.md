# Serverless CI/CD with safedeployments, as code.

:fr: Sommaire / :gb: Table of Contents
=================

<!--ts-->

- [:fr: Description du projet](#fr-description-du-projet)
- [:gb: Project Description](#gb-project-description)
  
---

# :fr: Description du projet

Ce projet sert de support à l'article de blog suivant: 
[https://joseph-mbimbi.fr/blog/serverless-cicd-demo-1](https://joseph-mbimbi.fr/blog/serverless-cicd-demo-1)

Il est la version "clean", améliorée et pas à pas du projet suivant: [https://github.com/mbimbij/aws-serverless-cicd-autonomie](https://github.com/mbimbij/aws-serverless-cicd-autonomie)

## Déploiement de la pipeline

0. Forker le repo [https://github.com/mbimbij/aws-serverless-cicd-demo](https://github.com/mbimbij/aws-serverless-cicd-demo)
1. Créer un compte pour l'environnement de test
2. Créer un compte pour l'environnement de prod
3. Créer un compte pour la pipeline
4. Définir les profiles suivants dans `~/.aws/config` et `~/.aws/credentials`
  - profile `operations`: le profile du compte dédié à l'éxécution de la pipeline,
  - profile `test`: le profile du compte faisant office d'environnement de test
  - profile `prod`: le profile du compte faisant office d'environnement de prod
5. Vérifier que les profiles sont bien renseignés dans le fichier `pipeline.env`
6. Lancer la création de la pipeline: `./create-pipeline.sh $APPLICATION_NAME`
7. Activez la connexion github dans compte d'opérations
8. Supprimer la pipeline: `./delete-pipeline.sh $APPLICATION_NAME`


# :gb: Project Description

This project is a support for the following blog article 
[https://joseph-mbimbi.fr/blog/serverless-cicd-demo-1](https://joseph-mbimbi.fr/blog/serverless-cicd-demo-1) 
(blog article only in french for the moment)

It is the improved, enhanced and step by step version of the following project: [https://github.com/mbimbij/aws-serverless-cicd-autonomie](https://github.com/mbimbij/aws-serverless-cicd-autonomie)

## pipeline deployment

0. Forker le repository [https://github.com/mbimbij/aws-serverless-cicd-demo](https://github.com/mbimbij/aws-serverless-cicd-demo)
1. Create an account that will be used as a test environment
2. Create an account that will be used as a prod environment
3. Create an account that will be used for pipeline execution
4. Define the following profiles in `~/.aws/config` et `~/.aws/credentials`
  - profile `operations`: dedicated to pipeline execution
  - profile `test`: dedicated to test environment
  - profile `prod`: dedicated to prod environment
5. Verify that the profiles are set appropriately in `pipeline.env` file
6. Launch the creation of the pipeline: `./create-pipeline.sh $APPLICATION_NAME`
7. Activate the github connection in the `operations` account
8. Delete the pipeline: `./delete-pipeline.sh $APPLICATION_NAME`