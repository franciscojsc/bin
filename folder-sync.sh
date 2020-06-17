#!/bin/bash

# Autor: Francisco Chaves <https://franciscochaves.com>
# Description: Synchronize files and folders between the server and the local environment.

# Configuration
CURRENT_FOLDER=${HOME}/workspaces/
REMOTE_FOLDER=/home/fulano/backup/workspaces/
USER=fulano
SERVER=172.17.0.2
REMOTE_CONNECTION=${USER}@${SERVER}:${REMOTE_FOLDER}
PASS=123456
SSH_HOME=${HOME}/.ssh
SSH_KEY=${SSH_HOME}/id_rsa
SSH_PORT=22

# Color
COLOR_DEFAULT="\033[0;0m"
COLOR_PRIMARY="\033[1;94m"
COLOR_SUCESS="\033[1;92m"
COLOR_DANGER="\033[1;31m"
COLOR_WARNING="\033[1;33m"

header() {
    echo -e "${COLOR_PRIMARY}"
    echo "╔═╗┌─┐┬  ┌┬┐┌─┐┬─┐  ┌─┐┬ ┬┌┐┌┌─┐"
    echo "╠╣ │ ││   ││├┤ ├┬┘  └─┐└┬┘││││  "
    echo "╚  └─┘┴─┘─┴┘└─┘┴└─  └─┘ ┴ ┘└┘└─┘"
    echo

    sleep 1
}

installRsync() {
    if [ -z $(which rsync) ]
	  then
        echo -e "${COLOR_PRIMARY}"
        echo "Installing the rsync program"
        echo -e "${COLOR_WARNING}"
        sudo apt-get -y install rsync
        sleep 2
        menu
	fi
}

installSSHpass() {
    if [ -z $(which sshpass) ]
	then
        echo -e "${COLOR_PRIMARY}"
        echo "Installing the sshpass program"
        echo -e "${COLOR_WARNING}"
        sudo apt-get -y install sshpass
        sleep 2
        menu
	fi
}

NoStrictHostKeyCheckingPrompt() {
    if [ -z "$(ssh-keygen -F ${SERVER})" ]
    then
        ssh-keyscan -H ${SERVER} | tee -a ${SSH_HOME}/known_hosts
        sleep 2
        menu
    fi
}

menu() {
    clear
    header
    NoStrictHostKeyCheckingPrompt
    installSSHpass
    installRsync

    echo 
    echo -e "${COLOR_WARNING} a) ${COLOR_DEFAULT} Synchronization 🔎 test? localhost ➔ server"
    echo
    echo -e "${COLOR_WARNING} b) ${COLOR_DEFAULT} Synchronization 🔎 test? server ➔ localhost"
    echo
    echo -e "${COLOR_WARNING} c) ${COLOR_DEFAULT} Synchronization? localhost ➔ server"
    echo
    echo -e "${COLOR_WARNING} d) ${COLOR_DEFAULT} Synchronization? server ➔ localhost"
    echo
    echo -e "${COLOR_WARNING} e) ${COLOR_DEFAULT} Exit"
    echo

    sleep 2

    read -n1 -s choice

    case $choice in
        A|a) echo -e "${COLOR_SUCESS}"
            if [ -z ${PASS} ]
            then
                rsync \
                --progress \
                --dry-run \
                --exclude "node_modules" \
                --delete \
                -avzhmi \
                -e "ssh -p ${SSH_PORT} -i ${SSH_KEY}" \
                $CURRENT_FOLDER $REMOTE_CONNECTION
            else
                sshpass -p ${PASS} \
                rsync \
                --progress \
                --dry-run \
                --exclude "node_modules" \
                --delete \
                -avzhmi \
                -e "ssh -p ${SSH_PORT} -i ${SSH_KEY}" \
                $CURRENT_FOLDER $REMOTE_CONNECTION
            fi
            sleep 4
            menu
            ;;
        B|b) echo -e "${COLOR_SUCESS}"
            if [ -z ${PASS} ]
            then
                rsync \
                --progress \
                --dry-run \
                --exclude "node_modules" \
                -avzhmi \
                -e "ssh -p ${SSH_PORT} -i ${SSH_KEY}" \
                $REMOTE_CONNECTION $CURRENT_FOLDER
            else
                sshpass -p ${PASS} \
                rsync \
                --progress \
                --dry-run \
                --exclude "node_modules" \
                -avzhmi \
                -e "ssh -p ${SSH_PORT} -i ${SSH_KEY}" \
                $REMOTE_CONNECTION $CURRENT_FOLDER
            fi
            sleep 4
            menu
            ;;
        C|c) echo -e "${COLOR_SUCESS}"
            if [ -z ${PASS} ]
            then
                rsync \
                --progress \
                --exclude "node_modules" \
                --delete \
                -avzhmi \
                -e "ssh -p ${SSH_PORT} -i ${SSH_KEY}" \
                $CURRENT_FOLDER $REMOTE_CONNECTION
            else
                sshpass -p ${PASS} \
                rsync \
                --progress \
                --exclude "node_modules" \
                --delete \
                -avzhmi \
                -e "ssh -p ${SSH_PORT} -i ${SSH_KEY}" \
                $CURRENT_FOLDER $REMOTE_CONNECTION
            fi
            sleep 4
            menu
            ;;
        D|d) echo -e "${COLOR_SUCESS}"
            if [ -z ${PASS} ]
            then
                rsync \
                --progress \
                --exclude "node_modules" \
                -avzhmi \
                -e "ssh -p ${SSH_PORT} -i ${SSH_KEY}" \
                $REMOTE_CONNECTION $CURRENT_FOLDER
            else
                sshpass -p ${PASS} \
                rsync \
                --progress \
                --exclude "node_modules" \
                -avzhmi \
                -e "ssh -p ${SSH_PORT} -i ${SSH_KEY}" \
                $REMOTE_CONNECTION $CURRENT_FOLDER
            fi
            sleep 4
            menu
            ;;
        E|e) echo -e "${COLOR_SUCESS}"
            echo "Operation Canceled"
            sleep 4
            footer
            exit 1
            ;;
        *) echo -e "${COLOR_DANGER}"
            echo "Incorrect option"
            sleep 4
            menu
            ;;
    esac
}

footer() {
    echo -e "${COLOR_PRIMARY}"
    echo "╔╗ ┬ ┬┌─┐"
    echo "╠╩╗└┬┘├┤ "
    echo "╚═╝ ┴ └─┘"
    echo
}

menu
