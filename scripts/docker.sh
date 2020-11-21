#!/bin/bash

PS3="Please select your choice: "
options=(
    "Install" \
    "View all" \
    "Stop containers" \
    "Prune images" \
    "Remove containers" \
    "Remove images" \
    "Clean all" \
    "Docker login" \
    "Quit")

select opt in "${options[@]}"; do
    case $opt in
        "Install")
            sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
            sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
            sudo apt-get update
            sudo apt-get install -y docker-ce docker-ce-cli containerd.io

            sudo usermod -aG docker ${USER}
            sudo systemctl enable docker
            systemctl list-unit-files | grep docker
            sudo systemctl start docker
            docker --version

            break
            ;;
            
        "View all")
            docker image ls && echo
            docker container ls && echo
            docker ps -a
            break
            ;;

        "Stop containers")
            docker stop $(docker ps -a -q)
            break
            ;;

        "Prune images")
            docker image prune -f
            break
            ;;

        "Remove containers")
            docker rm -f $(docker ps -a -q)
            break
            ;;

        "Remove images")
            docker rmi -f $(docker image ls -q)
            break
            ;;

        "Clean all")
            docker stop $(docker ps -a -q)
            docker rm -f $(docker ps -a -q)
            docker rmi -f $(docker image ls -q)
            break
            ;;

        "Docker login")
            docker login
            break
            ;;
            
        "Quit")
            break
            ;;
        *)
            echo "Invalid option"
            break
            ;;
    esac
done
