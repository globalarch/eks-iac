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
    MONGOS_SGP_IP="10.2.1.22" #Private IP
    MONGOS_ORE_IP="10.1.1.22" #Private IP

    echo "Cloning configuration scripts..."
    rm -rf k8s_poc
    mkdir k8s_poc && cd k8s_poc
    git clone -b global-arch-3 --single-branch https://github.com/SnapLogic/k8s-poc.git
    ls -l
    echo "Finished"

    grep -rl "$STRING_MONGO" "$(pwd)/k8s-poc" | xargs sed -i '' "s/$STRING_MONGO/$MONGOS_ORE_IP/g"
    cat ./k8s-poc/ephemeral-pods/config/properties/provisioned.yaml
    cd k8s-poc/ephemeral-pods
    aws eks update-kubeconfig --region us-west-2 --name global-arch-tf   
    kubectl get pods
    bash ./eks_main_setup_script.sh --all
    cd ../..
    grep -rl "$MONGOS_ORE_IP" "$(pwd)/k8s-poc" | xargs sed -i '' "s/$MONGOS_ORE_IP/$STRING_MONGO/g"
    cat ./k8s-poc/ephemeral-pods/config/properties/provisioned.yaml
 
    grep -rl "$STRING_MONGO" "$(pwd)/k8s-poc" | xargs sed -i '' "s/$STRING_MONGO/$MONGOS_SGP_IP/g"
    cat ./k8s-poc/ephemeral-pods/config/properties/provisioned.yaml
    cd k8s-poc/ephemeral-pods
    aws eks update-kubeconfig --region ap-southeast-1 --name global-arch-tf
    kubectl get pods
    bash ./eks_main_setup_script.sh --all_2
    cd ../..
    grep -rl "$MONGOS_SGP_IP" "$(pwd)/k8s-poc" | xargs sed -i '' "s/$MONGOS_SGP_IP/$STRING_MONGO/g"
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

	if [[ -n "${eks_flag}" ]]; then
		slservices
	fi
    
    if [[ -n "${reset_eks_flag}" ]]; then
		reset_eks
	fi
}

parse_options $@
main