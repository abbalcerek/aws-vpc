#/bin/bash

set -o allexport
source stack.env
set +o allexport

rm -f ${key_pair_name}.pem

aws ec2 delete-key-pair \
  --key-name ${key_pair_name}

aws ec2 delete-key-pair \
  --key-name test

aws ec2 create-key-pair \
  --key-name ${key_pair_name} \
  --query 'KeyMaterial' \
  --output text > ${key_pair_name}.pem

chmod 400 ${key_pair_name}.pem

aws cloudformation describe-stacks \
  --stack-name ${stack_name} || \
echo creating stack: && \
aws cloudformation create-stack \
  --stack-name ${stack_name} \
  --template-body file://stack.yaml \
  --parameters ParameterKey=KeyPairName,ParameterValue=${key_pair_name}

aws cloudformation wait stack-exists \
  --stack-name ${stack_name}
