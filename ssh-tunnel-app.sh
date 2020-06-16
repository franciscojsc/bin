#!/bin/bash

# Author: Francisco Chaves <https://franciscochaves.com>
# Description: Create an encrypted tunnel from the local environment to serve an application in the remote environment

# Run command on the SSH server: echo "GatewayPorts yes" | tee -a /etc/ssh/sshd_config && service ssh restart

# Configuration
PORT_LOCAL=5000
PORT_REMOTE=8080
SERVER=172.17.0.2
PORT=22
USER=fulano
PASS=123456
SSH_HOME=${HOME}/.ssh
SSH_KEY=${SSH_HOME}/id_rsa

tcp-forwarding() {
    # No StrictHostKeyChecking prompt
    if [ -z "$(ssh-keygen -F ${SERVER})" ]
    then
        ssh-keyscan -H ${SERVER} | tee -a ${SSH_HOME}/known_hosts
    fi
    
    clear
    echo -e "\\nApplication running on http://${SERVER}:${PORT_REMOTE}\\n"
    echo -e "\\nTo cancel press CTRL + C\\n"

    if [ -z $PASS ]
    then
        ssh -p ${PORT} -i ${SSH_KEY} -N -R ${PORT_REMOTE}:localhost:${PORT_LOCAL} ${USER}@${SERVER}
        if [ $? = 0 ]
        then
            echo ""
            exit 0
        fi
    else
        if [ ! -z $(which sshpass) ]
        then
            sshpass -p ${PASS} ssh -p ${PORT} -N -R ${PORT_REMOTE}:localhost:${PORT_LOCAL} ${USER}@${SERVER}
        else
            sudo apt-get -y install sshpass
            tcp-forwarding
        fi
    fi

    echo -e "\\nReload connection\\n"

    for i in $(seq 0 100); do
        sleep 0.1
        echo -n "."
    done

    tcp-forwarding
}

tcp-forwarding
