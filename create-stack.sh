#/bin/bash

set -o allexport
source stack.env
set +o allexport

aws cloudformation describe-stacks \
  --stack-name ${stack_name} || \
echo creating stack: && \
aws cloudformation create-stack \
  --stack-name ${stack_name} \
  --template-body file://stack.yaml

aws cloudformation wait stack-exists \
  --stack-name ${stack_name}
