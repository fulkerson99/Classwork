#!/bin/bash

#Declaration of variables

#Declare instance array




aws ec2 run-instances \
    --image-id ami-0817d428a6fb68645 \
    --instance-type t2.micro \
    --security-group-ids sg-08546f3802f02691 \
    --key-name desktoppc-ubuntu-vm2.priv \
    --availability-zones us-east-1a \
    --count 3 \
    --user-data file://install-env.sh ##Script executes upon launching of instance.



aws ec2 wait instance-running \
    --instance-ids $(aws ec2 describe-instances --query 'Reservations[].Instances[*].{Instance:InstanceId}' --output text ) \



aws elbv2 create-load-balancer \
    --name jf-ITMO-balance \
    --subnets subnet-1779d571 subnet-4ac5a344 \
    --security-group-ids sg-08546f3802f02691 \


aws elbv2 wait load-balancer-exists \
    --load-balancer-arns $(aws elbv2 describe-load-balancers --query 'LoadBalancers[].LoadBalancerArn[*].{LoadBalancerArn}' --output text) \
    --names jf-ITMO-balance \



aws ec2 describe load-balancer-available \
    --load-balancer-arns $(aws elbv2 describe-load-balancers --query 'LoadBalancers[].LoadBalancerArn[*].{LoadBalancerArn}' --output text) \
    --names jf-ITMO-balance \



aws elbv2 create-target-group \
    --name jf-ITMO-balance \
    --protocol HTTP \
    --port 80 \
    --target-type instance \
    --vpc-id 71c1390c

aws elbv2 register-targets \
    --target-group-arn $(aws elbv2 describe-target-groups --query 'TargetGroups[*].TargetGroupArn[*].{TargetGroupArn}' --output text) \
    --targets Id=$(aws ec2 describe-instances --query 'Reservations[].Instances[*].{Instance:InstanceId}' --output text ) \



aws elbv2 create-listener \

    --load-balancer-arn $(aws elbv2 describe-load-balancers --query 'LoadBalancers[].LoadBalancerArn[*].{LoadBalancerArn}' --output text) \
    --protocol HTTP \
    --port 80 \
    --default-actions Type=forward,TargetGroupArn=$(aws elbv2 describe-load-balancers --query 'LoadBalancers[].LoadBalancerArn[*].{LoadBalancerArn}' --output text) \

#Arn of target group
aws elbv2 modify-target-group \
    --target-group-arn $(aws elbv2 describe-load-balancers --query 'LoadBalancers[].LoadBalancerArn[*].{LoadBalancerArn}' --output text) \
    --health-check-protocol HTTP \
    --health-check-port 80 \

exit 0