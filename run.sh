#!/bin/bash
clear
echo "======================================================================================"
echo "==                                                                                  =="
echo "==   .d8888b.  888                    888                                           =="
echo "==  d88P  Y88b 888                    888                                           =="
echo "==  Y88b.      888                    888                                           =="
echo "==   \"Y888b.   88888b.   8888b.   .d88888  .d88b.  888  888  888 .d8888b            =="
echo "==      \"Y88b. 888 \"88b     \"88b d88\" 888 d88\"\"88b 888  888  888 88K                =="
echo "==        \"888 888  888 .d888888 888  888 888  888 888  888  888 \"Y8888b.           =="
echo "==  Y88b  d88P 888  888 888  888 Y88b 888 Y88..88P Y88b 888 d88P      X88           =="
echo "==   \"Y8888P\"  888  888 \"Y888888  \"Y88888  \"Y88P\"   \"Y8888888P\"   88888P'           =="
echo "==                                                                                  =="
echo "==            .d888             d8888 888    888                   888              =="
echo "==           d88P\"             d88888 888    888                   888              =="
echo "==           888              d88P888 888    888                   888              =="
echo "==   .d88b.  888888          d88P 888 888888 888  8888b.  88888b.  888888  8888b.   =="
echo "==  d88\"\"88b 888            d88P  888 888    888     \"88b 888 \"88b 888        \"88b  =="
echo "==  888  888 888           d88P   888 888    888 .d888888 888  888 888    .d888888  =="
echo "==  Y88..88P 888          d8888888888 Y88b.  888 888  888 888  888 Y88b.  888  888  =="
echo "==   \"Y88P\"  888         d88P     888  \"Y888 888 \"Y888888 888  888  \"Y888 \"Y888888  =="
echo "==                                                                                  =="
echo "======================================================================================"
echo "==                         -- RANVIER PACKAGE RUNNER --                             =="
echo "======================================================================================"
echo "=="
echo "==   LAUNCH MODES"
echo "==   ----------------------------------------------------------------"
echo "==   1 - Build Ranvier"
echo "==   2 - Build and Launch"
echo "==   3 - Launch Only"
echo "==   4 - Cancel and Exit"
echo "=="
echo "======================================================================================"
echo ""
read -p "Enter Launch Mode: " MODE

if [[ $MODE -gt 3 ]] || [[ $MODE -lt 1 ]]
then
	echo "Exiting..."
	echo ""
	exit 1
fi

# BUILD RANVIER
if [[ $MODE -eq 1 ]] || [[ $MODE -eq 2 ]]
then 
    echo "STAGE: BUILDING..."
    REPOSRC="https://github.com/RanvierMUD/ranviermud.git"
    LOCALREPO="packages/ranviermud"
    
    echo "BACKING UP PERSISTENCE..."
    cp -R "deploy/data/." "data/" 

    echo "DROPPING THE PREVIOUS BUILD..."
    rm -rf deploy
    mkdir deploy

    echo "UPDATING SOURCES..."
    LOCALREPO_VC_DIR=$LOCALREPO/.git
    if [ ! -d $LOCALREPO_VC_DIR ]
    then
        git clone $REPOSRC $LOCALREPO
    else
        cd $LOCALREPO
        git pull $REPOSRC
        cd ../..
    fi

    echo "COPYING SOURCE TO DEPLOYMENT FOLDER..."
    cp -R $LOCALREPO/. "deploy/"

    echo "CLEANING UP THE DEFAULT CONTENT PACKAGE..."
    rm -rf "deploy/bundles"
    rm -rf "deploy/data"

    echo "COPYING OVER THE PERSISTED DATA..."
    cp -R "data/." "deploy/data/"

    echo "COPYING OVER THE ENHANCED CONTENT..."
    cp -R "source/." "deploy/"

    echo "INSTALLING PREREQUISITES.."
    cd deploy
    npm ci
    cd ..

    echo "BUILD DONE."
    echo;
fi


# LAUNCH PRE-LOADED PACKAGE
if [[ $MODE -eq 2 ]] || [[ $MODE -eq 3 ]] 
then 
    echo "STAGE: LAUNCHING..."
    file="deploy/ranvier"

    if [ -f "$file" ]
    then
        cd deploy
        ./ranvier
    else
        echo;echo "RANVIER NOT BUILT! PLEASE BUILD AND RE-RUN.";echo;
        exit 1
    fi
fi
