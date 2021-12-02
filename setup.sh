#!/bin/bash 

export TAG=1.0.3

function requirements() {
    sudo apt-get update -y && sudo apt-get install ca-certificates curl gnupg lsb-release -y
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
}

function install_docker() {
    sudo apt-get update -y && sudo apt-get install docker-ce docker-ce-cli containerd.io -y
}

function install_compose() {
    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
}

function start_node(){
    echo "Starting node..."
    docker-compose config
    docker-compose -f docker-compose.yml up -d
    echo "Follow node with: docker logs -f nimiq-node"
    docker logs -f nimiq-node
}


if [ -x "$(command -v docker)" ]; then
    start_node
else
    echo "Docker not installed, Installing docker..."
    requirements
    install_docker
    install_compose
    echo " installing Docker done!"
    start_node
fi