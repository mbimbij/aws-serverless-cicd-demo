source pipeline.env

getAccountId () {
  aws sts get-caller-identity --profile $1 --query "Account" --output text
}

if [ -z $1 ]; then
  echo -e "usage:\n./create-pipeline.sh \$APPLICATION_NAME"
  exit 1
fi

applicationName=$1

operationsAccountId=$(getAccountId $ACCOUNT_OPERATIONS_PROFILE)
echo "operationsAccountId: $operationsAccountId"
testAccountId=$(getAccountId $ACCOUNT_TEST_PROFILE)
echo "testAccountId: $testAccountId"
prodAccountId=$(getAccountId $ACCOUNT_PROD_PROFILE)
echo "prodAccountId: $prodAccountId"
echo "github repo: $GITHUB_REPO"
s3BucketName="$operationsAccountId-$AWS_REGION-$applicationName-artifacts-bucket"
echo "s3BucketName: $s3BucketName"

echo "############################################################"
echo "deploying s3 artifacts bucket and kms key"
echo "############################################################"
aws cloudformation deploy \
  --stack-name $applicationName-pre-requesites-stack \
  --template-file pre-requesites.yml \
  --capabilities CAPABILITY_NAMED_IAM \
  --profile $ACCOUNT_OPERATIONS_PROFILE \
  --parameter-overrides ApplicationName=$applicationName S3BucketName=$s3BucketName TestAccountId=$testAccountId ProdAccountId=$prodAccountId

s3KmsKeyArn=$(aws cloudformation describe-stacks --stack-name $applicationName-pre-requesites-stack --profile $ACCOUNT_OPERATIONS_PROFILE --query "Stacks[*].Outputs[?OutputKey=='CMK'].OutputValue" --output text)
echo "s3KmsKeyArn: $s3KmsKeyArn"

echo "############################################################"
echo "deploying IAM roles in test account"
echo "############################################################"
aws cloudformation deploy \
  --stack-name $applicationName-roles-stack \
  --template-file pipeline-cross-account-deploy-stack.yml \
  --capabilities CAPABILITY_NAMED_IAM \
  --profile $ACCOUNT_TEST_PROFILE \
  --parameter-overrides ApplicationName=$applicationName OpsAccountId=$operationsAccountId S3BucketName=$s3BucketName S3KmsKeyArn=$s3KmsKeyArn

echo "############################################################"
echo "deploying IAM roles in prod account"
echo "############################################################"
aws cloudformation deploy \
  --stack-name $applicationName-roles-stack \
  --template-file pipeline-cross-account-deploy-stack.yml \
  --capabilities CAPABILITY_NAMED_IAM \
  --profile $ACCOUNT_PROD_PROFILE \
  --parameter-overrides ApplicationName=$applicationName OpsAccountId=$operationsAccountId S3BucketName=$s3BucketName S3KmsKeyArn=$s3KmsKeyArn

echo "############################################################"
echo "deploying pipeline in ops account"
echo "############################################################"
samStackName=$applicationName-sam-stack
aws cloudformation deploy \
  --stack-name $applicationName-pipeline-stack \
  --template-file pipeline-ops-account-stack.yml \
  --capabilities CAPABILITY_NAMED_IAM \
  --profile $ACCOUNT_OPERATIONS_PROFILE \
  --parameter-overrides ApplicationName=$applicationName SamStackName=$samStackName S3BucketName=$s3BucketName S3KmsKeyArn=$s3KmsKeyArn TestAccountId=$testAccountId ProdAccountId=$prodAccountId GithubRepo=$GITHUB_REPO

echo "############################################################"
echo "updating artifacts bucket kms key policy for cross-account access"
echo "############################################################"
aws cloudformation deploy \
  --stack-name $applicationName-pre-requesites-stack \
  --template-file pre-requesites.yml \
  --capabilities CAPABILITY_NAMED_IAM \
  --profile $ACCOUNT_OPERATIONS_PROFILE \
  --parameter-overrides ApplicationName=$applicationName S3BucketName=$s3BucketName TestAccountId=$testAccountId  ProdAccountId=$prodAccountId AddKmsPermissions=true