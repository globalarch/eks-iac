#!/bin/bash

function mongodb {
    echo "Preparing dependency..."
    echo "Finished"

    echo "Installing and configuring MongoDB onto instances..."
    rm inventory
    terraform output -raw inventory > inventory
    chmod 700 ./private_keys/*.pem

    ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory './provisioning/main.yaml'
    echo "Finished"
}

function slservices {
    STRING_MONGO="mongodb-rs-svc.mongodb.svc.cluster.local"
    MONGOS_ORE_IP="10.1.1.22" #Private IP
    MONGOS_SGP_IP="10.2.1.22" #Private IP


    K8S_POC_DIR="$(dirname ~/Documents/GitHub/k8s-poc/.)"
    export BRANCH='4.global_arch_prod'
    export BUILD=11367

    echo "Cloning configuration scripts..."
    rm -rf k8s_poc
    mkdir k8s_poc && cd k8s_poc

	if [[ ! -n "${K8S_POC_DIR}" ]]; then
        git clone -b global-arch-3 --single-branch https://github.com/SnapLogic/k8s-poc.git
	else
        echo "=============================HI====THERE================"
        echo "=====I===AM=========USING==============================="
        echo "========================LOCAL==========================="
        echo "==================K8S-POC======REPO====================="
        cp -r $K8S_POC_DIR .
    fi
    
    
    ls -l
    # cat ./k8s-poc/ephemeral-pods/eks_main_setup_script.sh | grep -e BRANCH -e BUILD
    echo "Finished"
    grep -rl "$STRING_MONGO" "$(pwd)/k8s-poc" | xargs sed -i '' "s/$STRING_MONGO/$MONGOS_SGP_IP/g"
    cat ./k8s-poc/ephemeral-pods/config/properties/provisioned.yaml
    cd k8s-poc/ephemeral-pods
    aws eks update-kubeconfig --region ap-southeast-1 --name global-arch-tf
    kubectl get pods
    bash ./eks_main_setup_script.sh --all
    cd ../..
    grep -rl "$MONGOS_SGP_IP" "$(pwd)/k8s-poc" | xargs sed -i '' "s/$MONGOS_SGP_IP/$STRING_MONGO/g"
    cat ./k8s-poc/ephemeral-pods/config/properties/provisioned.yaml


    grep -rl "$STRING_MONGO" "$(pwd)/k8s-poc" | xargs sed -i '' "s/$STRING_MONGO/$MONGOS_ORE_IP/g"
    cat ./k8s-poc/ephemeral-pods/config/properties/provisioned.yaml
    cd k8s-poc/ephemeral-pods
    aws eks update-kubeconfig --region us-west-2 --name global-arch-tf   
    kubectl get pods
    bash ./eks_main_setup_script.sh --all
    cd ../..
    grep -rl "$MONGOS_ORE_IP" "$(pwd)/k8s-poc" | xargs sed -i '' "s/$MONGOS_ORE_IP/$STRING_MONGO/g"
    cat ./k8s-poc/ephemeral-pods/config/properties/provisioned.yaml


}

function reset_eks {
    aws eks update-kubeconfig --region us-west-2 --name global-arch-tf   
    cd k8s_poc/k8s-poc/ephemeral-pods
    bash ./eks_main_setup_script.sh --delete 

    aws eks update-kubeconfig --region ap-southeast-1 --name global-arch-tf 
    cd k8s_poc/k8s-poc/ephemeral-pods
    bash ./eks_main_setup_script.sh --delete 
}

function reset_mongo {
    terraform destroy -auto-approve -target="module.us-west-2-mongo" -target="module.ap-southeast-1-mongo" && \
    terraform apply -auto-approve -target="module.us-west-2-mongo" -target="module.ap-southeast-1-mongo" && \
    mongodb
}

parse_options() {
    for arg in $@; do
        case ${arg} in
        --mongodb)
            mongodb_flag='true'
            ;;
        --eks)
            eks_flag='true'
            ;;
        --all)
            mongodb_flag='true'
            eks_flag='true'
            ;;
        --reset_eks)
            reset_eks_flag='true'
            ;;
        --reset_mongodb)
            reset_mongo_flag='true'
            ;;
        --usage)
            usage
            exit 0
            ;;
        *)
            echo "Unrecognized option: ${arg}"
            usage
            exit 1
            ;;
        esac
    done
}

function main() {
	if [[ -n "${mongodb_flag}" ]]; then
        mongodb
	fi
    if [[ -n "${reset_mongo_flag}" ]]; then
        reset_mongo
	fi
	if [[ -n "${eks_flag}" ]]; then
		slservices
	fi
    
    if [[ -n "${reset_eks_flag}" ]]; then
		reset_eks
	fi
}

parse_options $@
gimme-aws-creds && export $(cat ~/.aws/credentials | tr -d "[:blank:]" | head -4 | tail -3)
export SNAPS_AWS_ACCESS_KEY_ID=$aws_access_key_id 
export SNAPS_AWS_SECRET_KEY=$aws_secret_access_key 
export SNAPS_AWS_REGION=us-west-2 
export AWS_SESSION_TOKEN=$aws_session_token 
export AWS_PROFILE_NAME=snaplogic
main