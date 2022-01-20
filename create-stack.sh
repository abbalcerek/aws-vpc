#/bin/bash

. stack.env

aws --profile priv --region us-east-2 \
  cloudformation describe-stacks \
  --stack-name ${stack_name} || \
echo creating stack: && \
aws --profile priv --region us-east-2 \
  cloudformation create-stack \
  --stack-name ${stack_name} \
  --template-body file://stack.yaml

aws --profile priv --region us-east-2 \
  cloudformation wait stack-exists \
  --stack-name ${stack_name}