source pipeline.env

getAccountId () {
  aws sts get-caller-identity --profile $1 --query "Account" --output text
}

operationsAccountId=$(getAccountId $ACCOUNT_OPERATIONS_PROFILE)
testAccountId=$(getAccountId $ACCOUNT_TEST_PROFILE)

applicationName=serverless-cicd
s3BucketName="$applicationName-artifacts-bucket"
s3KmsKeyArn=$(aws cloudformation describe-stacks --stack-name $applicationName-pre-requesites-stack --profile $ACCOUNT_OPERATIONS_PROFILE --query \"Stacks[*].Outputs[?OutputKey=='CMK'].OutputValue\" --output text)


aws cloudformation delete-stack \
  --stack-name $applicationName-pre-requesites-stack \
  --profile $ACCOUNT_OPERATIONS_PROFILE
aws cloudformation delete-stack \
  --stack-name $applicationName-application-stack \
  --profile $ACCOUNT_TEST_PROFILE
aws cloudformation delete-stack \
  --stack-name $applicationName-roles-stack \
  --profile $ACCOUNT_PROD_PROFILE
aws cloudformation delete-stack \
  --stack-name $applicationName-application-stack \
  --profile $ACCOUNT_PROD_PROFILE
aws cloudformation delete-stack \
  --stack-name $applicationName-roles-stack \
  --profile $ACCOUNT_TEST_PROFILE
aws cloudformation delete-stack \
  --stack-name $applicationName-pipeline-stack \
  --profile $ACCOUNT_OPERATIONS_PROFILE
