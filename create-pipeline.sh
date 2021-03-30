source pipeline.env

getAccountId () {
  aws sts get-caller-identity --profile $1 --query "Account" --output text
}

operationsAccountId=$(getAccountId $ACCOUNT_OPERATIONS_PROFILE)
testAccountId=$(getAccountId $ACCOUNT_TEST_PROFILE)

applicationName=serverless-cicd
s3BucketName="$applicationName-artifacts-bucket"

echo "############################################################"
echo "deploying s3 artifacts bucket and kms key"
echo "############################################################"
aws cloudformation deploy \
  --stack-name $applicationName-pre-requesites-stack \
  --template-file pre-requesites.yml \
  --capabilities CAPABILITY_NAMED_IAM \
  --profile $ACCOUNT_OPERATIONS_PROFILE \
  --parameter-overrides ApplicationName=$applicationName S3BucketName=$s3BucketName TestAccountId=$testAccountId

s3KmsKeyArn=$(aws cloudformation describe-stacks --stack-name $applicationName-pre-requesites-stack --profile $ACCOUNT_OPERATIONS_PROFILE --query "Stacks[*].Outputs[?OutputKey=='CMK'].OutputValue" --output text)

echo "############################################################"
echo "deploying IAM roles in test account"
echo "############################################################"
aws cloudformation deploy \
  --stack-name $applicationName-roles-stack \
  --template-file pipeline-cross-account-deploy-stack.yml \
  --capabilities CAPABILITY_NAMED_IAM \
  --profile $ACCOUNT_TEST_PROFILE \
  --parameter-overrides OpsAccountId=$operationsAccountId S3BucketName=$s3BucketName S3KmsKeyArn=$s3KmsKeyArn

echo "############################################################"
echo "deploying pipeline in ops account"
echo "############################################################"
aws cloudformation deploy \
  --stack-name $applicationName-pipeline-stack \
  --template-file pipeline-ops-account-stack.yml \
  --capabilities CAPABILITY_NAMED_IAM \
  --profile $ACCOUNT_OPERATIONS_PROFILE \
  --parameter-overrides ApplicationName=$applicationName TestAccountId=$testAccountId S3BucketName=$s3BucketName S3KmsKeyArn=$s3KmsKeyArn

echo "############################################################"
echo "updating artifacts bucket kms key policy for cross-account access"
echo "############################################################"
aws cloudformation deploy \
  --stack-name $applicationName-pre-requesites-stack \
  --template-file pre-requesites.yml \
  --capabilities CAPABILITY_NAMED_IAM \
  --profile $ACCOUNT_OPERATIONS_PROFILE \
  --parameter-overrides ApplicationName=$applicationName S3BucketName=$s3BucketName TestAccountId=$testAccountId AddKmsPermissions=true