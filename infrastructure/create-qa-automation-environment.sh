# Environment variables
PATH="$PATH:/usr/local/bin"
APP_NAME="Petclinic"
CFN_KEYPAIR="serdar-$APP_NAME-dev-${BUILD_NUMBER}.key"
CFN_TEMPLATE="./infrastructure/dev-docker-swarm-infrastructure-cfn-template.yml"
AWS_REGION="us-east-1"
export ANSIBLE_PRIVATE_KEY_FILE="${WORKSPACE}/${CFN_KEYPAIR}"
export ANSIBLE_HOST_KEY_CHECKING=False
export APP_STACK_NAME="serdar-$APP_NAME-App-${BUILD_NUMBER}"
# Create key pair for Ansible
aws ec2 create-key-pair --region ${AWS_REGION} --key-name ${CFN_KEYPAIR} --query "KeyMaterial" --output text > ${CFN_KEYPAIR}
chmod 400 ${CFN_KEYPAIR}
# Create infrastructure for Docker Swarm
aws cloudformation create-stack --region ${AWS_REGION} --stack-name ${APP_STACK_NAME} --capabilities CAPABILITY_IAM --template-body file://${CFN_TEMPLATE} --parameters ParameterKey=KeyPairName,ParameterValue=${CFN_KEYPAIR}

# Install Docker Swarm environment on the infrastructure
# Update dynamic inventory (hosts/docker nodes)
sed -i "s/APP_STACK_NAME/$APP_STACK_NAME/" ./ansible/inventory/dev_stack_dynamic_inventory_aws_ec2.yml
# Install common tools on all instances/nodes
ansible-playbook -i ./ansible/inventory/dev_stack_dynamic_inventory_aws_ec2.yml -b ./ansible/playbooks/pb_setup_for_all_docker_swarm_instances.yml
# Initialize Docker Swarm on Grand Master
ansible-playbook -i ./ansible/inventory/dev_stack_dynamic_inventory_aws_ec2.yml -b ./ansible/playbooks/pb_initialize_docker_swarm.yml
# Join the manager instances to the Swarm
ansible-playbook -i ./ansible/inventory/dev_stack_dynamic_inventory_aws_ec2.yml -b ./ansible/playbooks/pb_join_docker_swarm_managers.yml
# Join the worker instances to the Swarm
ansible-playbook -i ./ansible/inventory/dev_stack_dynamic_inventory_aws_ec2.yml -b ./ansible/playbooks/pb_join_docker_swarm_workers.yml

# Build, Deploy, Test the application

# Tear down the Docker Swarm infrastructure
aws cloudformation delete-stack --region ${AWS_REGION} --stack-name ${AWS_STACK_NAME}
# Delete key pair
<<<<<<< HEAD
aws ec2 delete-key-pair --region ${AWS_REGION} --key-name ${CFN_KEYPAIR}
<<<<<<< HEAD
<<<<<<< HEAD
rm -rf ${CFN_KEYPAIR}
=======
rm -rf ${CFN_KEYPAIR}
>>>>>>> f35c98795b368f2519eafdfc4b5927169e5c247e
=======
rm -rf ${CFN_KEYPAIR}
>>>>>>> f35c98795b368f2519eafdfc4b5927169e5c247e
=======
aws ec2 delete-key-pair --region ${AWS_REGION} --key-name ${CFN_KEYPAIR}
>>>>>>> e50fa52178bd36250cb1f7ff09852bf20f35b92a
