#!/bin/bash

set -o allexport
source stack.env
set +o allexport

aws cloudformation update-stack \
  --stack-name ${stack_name} \
  --template-body file://stack.yaml \
  --parameters ParameterKey=KeyPairName,ParameterValue=stack_tmp_pair


echo "it is safe to exit script now. wating for stack to be updated"
