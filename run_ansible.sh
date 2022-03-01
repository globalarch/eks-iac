#!/bin/bash

rm inventory
terraform output -raw inventory > inventory
chmod 700 ./private_keys/*.pem

ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory './provisioning/main.yaml'
