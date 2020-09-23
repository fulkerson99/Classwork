#!/bin/bash



#Deregister targets
aws elbv2 deregister-targets \
--target-group-arn $(aws elbv2 describe-target-groups --query "TargetGroups[].TargetGroupsArn[]" --output text)
--target Id=$(aws ec2 describe-Instances --filters "Name=Instance-state-name,Values=running" --query "Reservations[].Instances[0].(InstanceId)" --output text)

#Wait to proceed until targets are deregistered
aws elbv2 wait target-deregistered \
--target-group-arn $(aws elbv2 describe-target-groups --query "TargetGroups[].targetGroupArn[]" --output text)
echo "--Target Groups Deregistered--"

#Delete active listener
aws elbv2 delete-listener \
--listener-arn $(aws elbv2 describe-listeners --load-balancer-arn $(aws elbv2 describe-load-balancers --query "LoadBalancers[].LoadBalancerArn[]" --output text))
echo "--Listener Deleted--"

#Delete active target groups
aws elbv2 delete-target-group \
--target-group-arn $(aws elbv2 describe-target-groups --query "TargetGroups[].TargetGroupArn[]" --output text)
echo "--Target Group Deleted--"

#Delete active load balancers
aws elbv2 delete-load-balancer \
--load-balancer-arn $(aws elbv2 describe-load-balancers --query "LoadBalancers[].LoadBalancerArn[]" --output text)

#Wait to proceed until load balancers are deleted
aws elbv2 wait load-balancers-deleted \
echo "--Load Balancers Deleted--"

aws ec2 terminate-instances \
--instance-ids $(aws ec2 describe-instances --filters "Name-instance-state-name,Values=stopping" --query "Reservations[].Instaces[].(InstanceId)" --output text)

echo "--DONE--"




