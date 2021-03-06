#!/bin/bash

#Declaration of variables

#Declare instance array




aws ec2 run-instances \
    --image-id ami-0817d428a6fb68645 \
    --instance-type t2.micro \
    --security-group-ids sg-08546f3802f02691 \
    --key-name desktoppc-ubuntu-vm2.priv \
    --count 3 \
    --user-data file://install-env.sh ##Script executes upon launching of instance.



aws ec2 wait instance-running \
    --instance-ids $(aws ec2 describe-instances --query 'Reservations[].Instances[*].{Instance:InstanceId}' --output text ) \



aws elbv2 create-load-balancer \
    --name jf-ITMO-balance \
    --subnets subnet-1779d571 subnet-4ac5a344 \
    --security-group-ids sg-08546f3802f02691 \


aws elbv2 wait load-balancer-exists \
    --load-balancer-arns $(aws elbv2 describe-load-balancers --query 'LoadBalancers[].LoadBalancerArn[*].{Arn:LoadBalancerArn}' --output text) \
    



aws ec2 describe load-balancer-available \
    --load-balancer-arns $(aws elbv2 describe-load-balancers --query 'LoadBalancers[].LoadBalancerArn[*].{Arn:LoadBalancerArn}' --output text) \
    --names jf-ITMO-balance \


# Create Target groups
aws elbv2 create-target-group \
    --name jf-ITMO-balance \
    --protocol HTTP \
    --port 80 \
    --target-type instance \
    --vpc-id 71c1390c

# Register Target Groups
aws elbv2 register-targets \
    --target-group-arn $(aws elbv2 describe-target-groups --query 'TargetGroups[*].TargetGroupArn[*].{Arn:TargetGroupArn}' --output text) \
    --targets Id=$(aws ec2 describe-instances --query 'Reservations[].Instances[*].{Instance:InstanceId}' --output text ) \


# Create listener
aws elbv2 create-listener \

    --load-balancer-arn $(aws elbv2 describe-load-balancers --query 'LoadBalancers[].LoadBalancerArn[*].{Arn:LoadBalancerArn}' --output text) \
    --protocol HTTP \
    --port 80 \
    --default-actions Type=forward,TargetGroupArn=$(aws elbv2 describe-load-balancers --query 'LoadBalancers[].LoadBalancerArn[*].{Arn:LoadBalancerArn}' --output text) \

#Arn of target group
aws elbv2 modify-target-group \
    --target-group-arn $(aws elbv2 describe-load-balancers --query 'LoadBalancers[].LoadBalancerArn[*].{Arn:LoadBalancerArn}' --output text) \
    --health-check-protocol HTTP \
    --health-check-port 80 \

exit 0