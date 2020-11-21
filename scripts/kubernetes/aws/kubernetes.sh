#!/bin/bash

PS3="Please select your choice: "
options=(
    "AWS CLI, install" \
    "AWS CLI, configure" \
    "AWS-EKS, install kubectl" \
    "AWS-EKS, uninstall kubectl" \
    "AWS-EKS, install eksctl" \
    "AWS-EKS, uninstall eksctl" \
    "AWS-EKS, connect" \
    "AWS-EKS, create dashboard" \
    "AWS-EKS, connect to the dashboard" \
    "AWS-ECR, login" \
    "Quit")

select opt in "${options[@]}"; do
    case $opt in
        "AWS CLI, install")
            curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "$HOME/awscliv2.zip"
            unzip -q $HOME/awscliv2.zip -d $HOME
            rm $HOME/awscliv2.zip
            sudo $HOME/aws/install
            #pip3 install awscli --upgrade --user
            break
            ;;

        "AWS CLI, configure")
            aws --version
            aws configure
            #aws configure --profile <name>
            #export AWS_PROFILE=<name>
            break
            ;;

        "AWS-EKS, install kubectl")
            sudo rm -f $HOME/.kube/config
            sudo mkdir -p $HOME/bin
            curl -o ./kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.18.9/2020-11-02/bin/linux/amd64/kubectl
            chmod +x ./kubectl
            mkdir -p $HOME/bin
            mv ./kubectl $HOME/bin/kubectl
            export PATH=$HOME/bin:$PATH
            echo "Kubectl $(kubectl version --short --client)"
            echo -e "===========\nAdd the \$HOME/bin path to your shell initialization file so that it is configured when you open a shell.\n==========="
            #echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
            break
            ;;

        "AWS-EKS, uninstall kubectl")
            sudo rm $HOME/bin/kubectl
            sudo rm -f $HOME/.kube/config
            echo "Kubectl $(kubectl version --short --client)"
            break
            ;;

        "AWS-EKS, install eksctl")
            curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
            sudo mv /tmp/eksctl /usr/local/bin
            echo "eksctl version: $(eksctl version)"
            break
            ;;

        "AWS-EKS, uninstall eksctl")
            sudo rm /usr/local/bin/eksctl
            echo 'Done.'
            break
            ;;

        "AWS-EKS, connect")
            aws sts get-caller-identity
            aws eks list-cluster
            read -p 'Region [eu-west-2]: ' REGION
            if [ -z "$REGION" ]; then
                REGION='eu-west-2'
            fi
            read -p 'Cluster name: ' NAME
            aws eks --region $REGION update-kubeconfig --name $NAME
            kubectl get svc
            kubectl get pods --all-namespaces
            break
            ;;

        "AWS-EKS, create dashboard")
            kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.3.6/components.yaml
            kubectl get deployment metrics-server -n kube-system
            kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta8/aio/deploy/recommended.yaml
            kubectl apply -f ./scripts/kubernetes/aws/eks-admin-service-account.yaml
            break
            ;;

        "AWS-EKS, connect to the dashboard")
            kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep eks-admin | awk '{print $1}')
            echo -e '\nhttp://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#!/login'
            kubectl proxy
            break
            ;;

        "AWS-ECR, login")
            read -p 'Region [eu-west-2]: ' REGION
            if [ -z "$REGION" ]; then
                REGION='eu-west-2'
            fi
            read -p 'Username: ' USER
            read -p 'Password-stdin: ' -s PASSWORD
            aws ecr get-login-password --region $REGION | docker login --username $USER --password-stdin $PASSWORD
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
