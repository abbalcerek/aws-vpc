#!/bin/bash

set -o allexport
source stack.env
set +o allexport

aws cloudformation delete-stack \
  --stack-name ${stack_name}

echo "it is safe to exit script now. wating for stack to be removed"

aws cloudformation wait stack-delete-complete \
  --stack-name ${stack_name}
