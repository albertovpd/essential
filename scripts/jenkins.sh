#!/bin/bash

PS3="Please select your choice: "
options=(
    "Install" \
    "Enable Docker and DockerHub" \
    "Deploy key" \
    "Run tunnel to Jenkins local port" "Test key" \
    "Unintall" \
    "Quit")

select opt in "${options[@]}"; do
    case $opt in
        "Install")
            wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
            sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
            sudo apt-get update
            sudo apt-get install -y jenkins
            sudo sed -i -E "s/HTTP_PORT=.*/HTTP_PORT=9090/g" /etc/default/jenkins
            sudo systemctl restart jenkins
            sudo systemctl status jenkins
            echo -e "\nVisit http://localhost:9090 in the browser"
            break
            ;;

        "Enable Docker and DockerHub")
            sudo usermod -aG docker jenkins
            sudo su -s /bin/bash jenkins -c "docker login"
            sudo systemctl restart jenkins
            break
            ;;

        "Deploy key")
            sudo su -s /bin/bash jenkins -c "whoami && ssh-keygen -t rsa"
            sudo cat /var/lib/jenkins/.ssh/id_rsa.pub
            echo 'Copy and paste the deploy key above. For example, if you are using GitHub visit https://github.com/<user>/<repo>/settings/keys'
            break
            ;;

        "Run tunnel to Jenkins local port")
            # Create/update a webhook with it.
            # For example, in GitHub add a webhook with payload url https://<id>.ngrok.io/github-webhook/
            ngrok http localhost:9090
            break
            ;;

        "Test key")
            sudo su -s /bin/bash jenkins -c "whoami && ssh git@github.com"
            break
            ;;

        "Unintall")
            sudo apt-get purge -y jenkins
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
