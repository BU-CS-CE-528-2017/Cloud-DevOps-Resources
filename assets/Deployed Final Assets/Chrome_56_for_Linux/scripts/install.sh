#!/bin/bash

# Created by David Asbjornsson	(2/22/17)

########################## SPECIAL ENVIRONMENT VARIABLES ##########################

echo "CONS3RT_HOME = ${CONS3RT_HOME}"
echo "ASSET_DIR = ${ASSET_DIR}"
echo "DEPLOYMENT_HOME = ${DEPLOYMENT_HOME}"
echo "List the contents of ASSET_DIR:"
find ${ASSET_DIR}
echo "DEPLOYMENT_HOME = ${DEPLOYMENT_HOME}"
echo "List the contents of deployment.properties:"
cat ${DEPLOYMENT_HOME}/deployment.properties

########################## INSTALLATION ##########################

# Location to install Chrome to
chromeBaseDir="/opt"
# Locate the media directory
mediaDir=${ASSET_DIR}/media
# Get installer file name
chromeInstaller=$(ls ${mediaDir})
# Get full installer path
chromeInstallerPath="${mediaDir}/${chromeInstaller}"
# Install Chrome using the .deb file
dpkg -i $(chromeInstallerPath) -C ${chromeBaseDir}

######################## EXIT CODES ########################

exitCode=0

echo "Exiting with code ${exitCode}"
exit #{exitCode}

