#!/bin/bash

PS3="Please select your choice: "
options=(
    "Miniconda 3, install" \
    "Miniconda 3, uninstall" \
    "Open Spyder" \
    "Notebook, start" \
    "Notebook, choose browser" \
    "Quit")

select opt in "${options[@]}"; do
    case $opt in
        "Miniconda 3, install")
            rm -f /tmp/Miniconda3-latest-Linux-x86_64.sh
            wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -P /tmp
            bash /tmp/Miniconda*.sh -b -p $HOME/miniconda
            
            eval "$($HOME/miniconda/bin/conda shell.bash hook)"
            conda init bash
            conda config --add channels conda-forge
            conda update -y --all
            conda env update -f ./scripts/environment.yml --prune
            echo -e '===========\nRun the following command to restart environment variables: $ source $HOME/.bashrc\n==========='
            break
            ;;
            
        "Miniconda 3, uninstall")
            eval "$($HOME/miniconda/bin/conda shell.bash hook)"
            conda activate base
            anaconda-clean --yes
            conda init --reverse bash
            rm -rf $HOME/miniconda $HOME/.*conda*
            echo -e '===========\nRun the following command to restart environment variables: $ source $HOME/.bashrc\n==========='
            break
            ;;

        "Open Spyder")
            conda info --envs
            spyder 1> /dev/null 2>&1 &
            break
            ;;

        "Notebook, start")
            conda info --envs
            cd $HOME
            jupyter notebook
            break
            ;;

        "Notebook, choose browser")
            conda info --envs
            jupyter notebook --generate-config
            echo 'change c.NotebookApp.browser'
            echo 'Where is Firefox?'
            whereis firefox
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
