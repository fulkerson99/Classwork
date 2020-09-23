#!/bin/bash

#Declaration of variables

#Declare instance array

declare -a instance_id[0]


aws ec2 run-instances \
    --image-id ami-07efac79022b86107 \
    --instance-type t2.micro \
    --count 3\
    --security-group-ids sg-0578335deaea2113a8 \
    --key-name desktoppc-ubuntu-vm2.priv \
    --user-data file://install-env.sh ##Script executes upon launching of instance.



aws ec2 describe-instances \
    --query 'Reservations[*].Instances[*].{Instance:InstanceId}' \
    --output text \



aws ec2 wait instance-running \
    --instance-ids $(instance_id[0],instance_id[1],instance_id[2]) \



aws elbv2 create-load-balancer \
    --name jf-ITMO-balance \
    --subnets subnet-1779d571 subnet-4ac5a344 \

declare -a load_balance_arn[0]

aws elbv2 describe-load-balancer-arns  \
    --output  = `load_balance_arn[*]` \
    --query Reservation[0].{`arn`} \


aws elbv2 wait load-balancer-exists \
    --load-balancer-arns $(load_balance_arn[0],load_balance_arn[1],load_balance_arn[2],) \
    --names jf-ITMO-balance \



aws ec2 describe load-balancer-available \
    --load-balancer-arns $(load_balance_arn) \
    --names jf-ITMO-balance \



aws elbv2 create-target-group \
    --name jf-ITMO-balance \
    --protocol HTTP \
    --port 80 \
    --target-type instance \
    --vpc-id 71c1390c


aws elbv2 describe-target-groups \
    --output = `target_group_arn` \
    --query Reservations[0].{`arn`} \

aws elbv2 register-targets \
    --target-group-arn $(target_group_arn) \
    --targets Id=$(instance_id) \



aws elbv2 create-listener \

    --load-balancer-arn $(load_balancer_arn) \
    --protocol HTTP \
    --port 80 \
    --default-actions Type=forward,TargetGroupArn=arn:aws:elasticloadbalancing:us-west-2:123456789012:targetgroup/my-targets/73e2d6bc24d8a067 \

#Arn of target group
aws elbv2 modify-target-group \
    --target-group-arn $(target_group_arn) \
    --health-check-protocol HTTP \
    --health-check-port 80 \

exit 0