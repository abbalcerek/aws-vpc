# aws-vpc

Cloud formation stack creating vpc with subnets and ec2 instances

### stack content

1) vpc
2) two public subnets
3) internet gateway
4) route tables
5) ec2 instance with security policy

### configuration

configuraiton of the stack is placed in `stack.env` file

### deployment

1) creating stack (creates stack and ssh key pair used to connect to ec2 instances)

```bash
./create-stack.sh
```

2) deleting stack (and ssh key pair)
```bash
./delete-stack.sh
```

3) update stack (if ssh key name will change stack will be update, if key will be replaced with the key with the same name stack will be broaken)
```bash
./update-stack.sh
```