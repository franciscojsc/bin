#!/bin/bash

# Author: Francisco Chaves <https://franciscochaves.com>
# Description: Add the SSH keys to the SSH agent in the local environment.

KEY_SSH_HOME=${HOME}/.ssh
PASS=

if [ -d "${KEY_SSH_HOME}" ]
then
    chmod 700 ${KEY_SSH_HOME}
fi

if [ -f "${KEY_SSH_HOME}/authorized_keys" ]
then
    chmod 644 ${KEY_SSH_HOME}/authorized_keys
fi

if [ -f "${KEY_SSH_HOME}/known_hosts" ]
then
    chmod 644 ${KEY_SSH_HOME}/known_hosts
fi

if [ -f "${KEY_SSH_HOME}/config" ]
then
    chmod 644 ${KEY_SSH_HOME}/config
fi

if [ -f "${KEY_SSH_HOME}/*_rsa" ]
then
    chmod 600 ${KEY_SSH_HOME}/*_rsa
fi

if [ -f "${KEY_SSH_HOME}/*_rsa.pub" ]
then
    chmod 644 ${KEY_SSH_HOME}/*_rsa.pub
fi

if [ -z "${PASS}" ]
then
	#eval "$(ssh-agent -s)"
	ssh-agent
	ssh-add ${KEY_SSH_HOME}/*_rsa
else
	if [ -z $(which sshpass) ]
	then
		sudo apt-get -y install sshpass
	fi
    #eval "$(ssh-agent -s)"
    ssh-agent
    sshpass -P 'Enter passphrase for' -p ${PASS} ssh-add ${KEY_SSH_HOME}/*_rsa
fi
