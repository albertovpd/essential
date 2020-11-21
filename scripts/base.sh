#!/bin/bash

PS3="Please select your choice: "
options=(
    "Essential, install" \
    "Connect your ngrok account (tunnel to localhost)" \
    "Essential GUI, install" \
    "Upgrade and clean all" \
    "Quit")

select opt in "${options[@]}"; do
    case $opt in
        "Essential, install")
            sudo apt-get update
            sudo apt-get install -y build-essential curl dos2unix git git-flow nano nmon openssh-client openssh-server snapd tree wget zip
            sudo snap install helm --classic

            sudo apt-get install -y openjdk-8-jdk openjdk-8-jre
            java -version
            echo >> $HOME/.bashrc
            echo '# Java OpenJDK 8' >> $HOME/.bashrc
            echo 'export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64' >> $HOME/.bashrc
            echo 'export PATH=$JAVA_HOME/jre/bin:$PATH' >> $HOME/.bashrc
            sudo update-alternatives --config java

            echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
            curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | sudo apt-key add
            sudo apt-get update
            sudo apt-get install -y sbt

            wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip -P /tmp
            sudo unzip /tmp/ngrok-stable-linux-amd64.zip -d /usr/local/bin
            rm /tmp/ngrok-stable-linux-amd64.zip
            sudo chmod +x /usr/local/bin/ngrok
            ngrok version

            echo -e '===========\nRun the following command to restart environment variables: $ source $HOME/.bashrc\n==========='
            break
            ;;

        "Connect your ngrok account (tunnel to localhost)")
            echo 'Connect with your ngrok account (tunnel to localhost) visiting https://ngrok.com'
            read -p 'ngrok authtoken: ' -s NGROK_TOKEN
            ngrok authtoken $NGROK_TOKEN
            break
            ;;

        "Essential GUI, install")
            sudo apt-get update
            sudo apt-get install -y firefox firefox-locale-es gnome-disk-utility pavucontrol redshift-gtk
            sudo apt-get install -y geany gitg terminator
            sudo snap install chromium
            sudo snap install code --classic
            sudo snap install dbeaver-ce
            sudo snap install intellij-idea-community --classic
            sudo snap install opera
            sudo snap install pycharm-community --classic
            sudo snap install slack --classic
            sudo snap install zotero-snap
            wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb -P $HOME
            sudo dpkg -i $HOME/teamviewer_amd64.deb
            sudo apt-get install -y --fix-broken
            rm $HOME/teamviewer_amd64.deb
            sudo update-alternatives --config x-www-browser
            sudo update-alternatives --config x-terminal-emulator
            break
            ;;

        "Upgrade and clean all")
            sudo apt-get update
            sudo apt-get upgrade -y
            sudo apt-get autoremove -y
            sudo apt-get autoclean
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
