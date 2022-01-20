#!/bin/bash

. stack.env

aws --profile priv --region us-east-2 \
  cloudformation update-stack \
  --stack-name ${stack_name} \
  --template-body file://stack.yaml 