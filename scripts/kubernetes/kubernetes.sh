#!/bin/bash

PS3="Please select your choice: "
options=(
    "VirtualBox, install" \
    "Minikube, install" \
    "Minikube, uninstall" \
    "Minikube, start" \
    "Minikube, create dashboard" \
    "Minikube, stop" \
    "Minikube, stop and delete" \
    "Minikube, pull docker image"\
    "Contexts info" \
    "Use context" \
    "Cluster info" \
    "Get Kubernetes master" \
    "Run tunnel to Minikube local URL" \
    "Quit")

select opt in "${options[@]}"; do
    case $opt in
        "VirtualBox, install")
            sudo apt-get install -y virtualbox virtualbox-ext-pack
            break
            ;;

        "Minikube, install")
            sudo curl -L https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 -o /usr/local/bin/minikube
            sudo chmod +x /usr/local/bin/minikube
            sudo snap install kubectl --channel=1.18/stable --classic
            minikube version --short
            echo "Kubectl $(kubectl version --short --client)"
            break
            ;;

        "Minikube, uninstall")
            sudo snap remove kubectl
            sudo rm /usr/local/bin/minikube
            echo 'minikube removed'
            break
            ;;

        "Minikube, start")
            if hash virtualbox 2>/dev/null; then
                K8S_DRIVER='virtualbox'
            else
                K8S_DRIVER='docker'
            fi
            read -p 'CPUs [4]: ' K8S_CPUS
            if [ -z "$K8S_CPUS" ]; then
                K8S_CPUS='4'
            fi
            read -p 'Memory [12g]: ' K8S_MEMORY
            if [ -z "$K8S_MEMORY" ]; then
                K8S_MEMORY='12g'
            fi
            read -p 'Disk size [25g]: ' K8S_DISK_SIZE
            if [ -z "$K8S_DISK_SIZE" ]; then
                K8S_DISK_SIZE='25g'
            fi
            minikube start \
                --addons metrics-server --addons dashboard \
                --driver $K8S_DRIVER \
                --kubernetes-version=1.18.9 \
                --cpus $K8S_CPUS \
                --memory $K8S_MEMORY \
                --disk-size $K8S_DISK_SIZE
            kubectl cluster-info
            break
            ;;

        "Minikube, create dashboard")
            echo 'Starting dashboard, please wait...'
            TMP_MINIKUBE=/tmp/bigdataplatform/kubernetes/dashboard
            rm -fr $TMP_MINIKUBE
            mkdir -p $TMP_MINIKUBE
            minikube dashboard --url=true > $TMP_MINIKUBE/minikube-dashboard.log 2>&1 &
            while [[ "$(cat $TMP_MINIKUBE/minikube-dashboard.log)" != *"http://"* ]]; do
                sleep 5
            done
            cat $TMP_MINIKUBE/minikube-dashboard.log
            break
            ;;

        "Minikube, stop")
            minikube stop
            break
            ;;

        "Minikube, stop and delete")
            minikube stop
            minikube delete
            break
            ;;

        "Minikube, pull docker image")
            eval $(minikube docker-env)
            docker login
            read -p 'Repository: ' NAME
            docker pull $NAME
            docker image ls
            eval $(minikube docker-env -u)
            break
            ;;

        "Contexts info")
            kubectl config get-contexts
            kubectl config current-context
            break
            ;;

        "Use context")
            read -p 'Name: ' NAME
            kubectl config use-context $NAME
            break
            ;;

        "Cluster info")
            kubectl cluster-info
            kubectl get nodes
            break
            ;;

        "Get Kubernetes master")
            K8S_MASTER=$(kubectl cluster-info | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g" | awk -F' ' 'NR==1{print $6; exit}')
            echo $K8S_MASTER
            break
            ;;

        "Run tunnel to Minikube local URL")
            ngrok http $(kubectl cluster-info | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g" | awk -F' ' 'NR==1{print $6; exit}')
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
