#!/bin/bash
set -e
module load Java
module load Maven

ANT_FOLDER=ant
ROADRUNNER_FOLDER=roadrunner
JCTOOLS_FOLDER=jctools
BALOK_FOLDER=balok

if [ ! -e ${ANT_FOLDER} ]; then
mkdir ${ANT_FOLDER}
cd ${ANT_FOLDER}
wget http://apache.cs.utah.edu//ant/binaries/apache-ant-1.10.5-bin.tar.gz
tar -xzvf apache-ant-1.10.5-bin.tar.gz
cd ..
fi
export PATH="${PATH}:$(pwd)/${ANT_FOLDER}/apache-ant-1.10.5/bin"

if [ ! -e ${JCTOOLS_FOLDER} ]; then
mkdir ${JCTOOLS_FOLDER}
git clone https://github.com/JCTools/JCTools.git ${JCTOOLS_FOLDER}
#git clone https://github.com/franz1981/JCTools.git ${JCTOOLS_FOLDER}
fi
cd ${JCTOOLS_FOLDER} && mvn install
cd ..

if [ ! -e ${BALOK_FOLDER} ]; then
mkdir ${BALOK_FOLDER}
git clone https://gitlab.com/cogumbreiro/balok.git ${BALOK_FOLDER}
fi
cd ${BALOK_FOLDER} && git checkout roadrunner && ./gradlew jarAllDeps
cd ..

if [ ! -e ${ROADRUNNER_FOLDER} ]; then
mkdir ${ROADRUNNER_FOLDER}
git clone https://github.com/FuriousBerserker/NewBalok.git ${ROADRUNNER_FOLDER}
fi
cd ${ROADRUNNER_FOLDER}
cd jars
cp ../../${JCTOOLS_FOLDER}/jctools-core/target/jctools-core-2.2-SNAPSHOT.jar .
ln -s ../../${BALOK_FOLDER}/build/libs/balok-1.0-dev-all-deps.jar balok-1.0-dev-all-deps.jar 
cd ..
ant
echo "Installation Completed"
