#!/bin/bash

. stack.env

# stack_id=$(aws --profile priv --region us-east-2 \
#   cloudformation describe-stacks \
#   --stack-name ${stack_name} | jq .Stacks[0].StackId)

# echo $stack_id

aws --profile priv --region us-east-2 \
  cloudformation delete-stack \
  --stack-name ${stack_name}

aws --profile priv --region us-east-2 \
  cloudformation wait stack-delete-complete \
  --stack-name ${stack_name}
