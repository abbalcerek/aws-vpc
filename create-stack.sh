#/bin/bash

set -o allexport
source stack.env
set +o allexport


rm -f ${key_pair_name}.pem


aws ec2 delete-key-pair \
  --key-name ${key-pair-name}

key=$(aws ec2 create-key-pair \
  --key-name ${key-pair-name} | jq .KeyMaterial )
  
echo ${key:1:-1} | sed 's/\\n/\n/g' > ${key_pair_name}.pem

aws cloudformation describe-stacks \
  --stack-name ${stack_name} || \
echo creating stack: && \
aws cloudformation create-stack \
  --stack-name ${stack_name} \
  --template-body file://stack.yaml \
  --parameters ParameterKey=KeyPairName,ParameterValue=${key_pair_name}

aws cloudformation wait stack-exists \
  --stack-name ${stack_name}
