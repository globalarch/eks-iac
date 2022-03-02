#!/bin/bash

BRANCH='4.global_arch_prod'
BUILD=11323


#Login 
printf '0\n' | gimme-aws-creds
aws ecr get-login-password --region us-west-2 --profile snaplogic | \
docker login --username AWS --password-stdin 694702677705.dkr.ecr.us-west-2.amazonaws.com

docker pull 694702677705.dkr.ecr.us-west-2.amazonaws.com/ephemeral_bootstrap:develop
docker pull 694702677705.dkr.ecr.us-west-2.amazonaws.com/sldb:$BRANCH-$BUILD
docker pull 694702677705.dkr.ecr.us-west-2.amazonaws.com/slserver:$BRANCH-$BUILD
docker pull 694702677705.dkr.ecr.us-west-2.amazonaws.com/slsched:$BRANCH-$BUILD
docker pull 694702677705.dkr.ecr.us-west-2.amazonaws.com/sltest:$BRANCH-$BUILD
docker pull 694702677705.dkr.ecr.us-west-2.amazonaws.com/jcc:$BRANCH-$BUILD
docker pull 694702677705.dkr.ecr.us-west-2.amazonaws.com/ccproxy:$BRANCH-$BUILD

aws ecr get-login-password --region us-west-2 --profile default | \
docker login --username AWS --password-stdin 343344284471.dkr.ecr.us-west-2.amazonaws.com
docker tag 694702677705.dkr.ecr.us-west-2.amazonaws.com/ephemeral_bootstrap:develop 343344284471.dkr.ecr.us-west-2.amazonaws.com/ephemeral_bootstrap:develop
docker tag 694702677705.dkr.ecr.us-west-2.amazonaws.com/sldb:$BRANCH-$BUILD  343344284471.dkr.ecr.us-west-2.amazonaws.com/sldb:$BRANCH-$BUILD 
docker tag 694702677705.dkr.ecr.us-west-2.amazonaws.com/slserver:$BRANCH-$BUILD  343344284471.dkr.ecr.us-west-2.amazonaws.com/slserver:$BRANCH-$BUILD 
docker tag 694702677705.dkr.ecr.us-west-2.amazonaws.com/slsched:$BRANCH-$BUILD  343344284471.dkr.ecr.us-west-2.amazonaws.com/slsched:$BRANCH-$BUILD 
docker tag 694702677705.dkr.ecr.us-west-2.amazonaws.com/sltest:$BRANCH-$BUILD  343344284471.dkr.ecr.us-west-2.amazonaws.com/sltest:$BRANCH-$BUILD 
docker tag 694702677705.dkr.ecr.us-west-2.amazonaws.com/jcc:$BRANCH-$BUILD  343344284471.dkr.ecr.us-west-2.amazonaws.com/jcc:$BRANCH-$BUILD 
docker tag 694702677705.dkr.ecr.us-west-2.amazonaws.com/ccproxy:$BRANCH-$BUILD  343344284471.dkr.ecr.us-west-2.amazonaws.com/ccproxy:$BRANCH-$BUILD 

docker push 343344284471.dkr.ecr.us-west-2.amazonaws.com/ephemeral_bootstrap:develop
docker push 343344284471.dkr.ecr.us-west-2.amazonaws.com/sldb:$BRANCH-$BUILD
docker push 343344284471.dkr.ecr.us-west-2.amazonaws.com/slserver:$BRANCH-$BUILD
docker push 343344284471.dkr.ecr.us-west-2.amazonaws.com/slsched:$BRANCH-$BUILD
docker push 343344284471.dkr.ecr.us-west-2.amazonaws.com/sltest:$BRANCH-$BUILD
docker push 343344284471.dkr.ecr.us-west-2.amazonaws.com/jcc:$BRANCH-$BUILD
docker push 343344284471.dkr.ecr.us-west-2.amazonaws.com/ccproxy:$BRANCH-$BUILD