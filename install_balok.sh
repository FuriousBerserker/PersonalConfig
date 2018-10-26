#!/bin/bash
set -e
#module load Java
#module load Maven

ANT_FOLDER=ant
ROADRUNNER_FOLDER=roadrunner
JCTOOLS_FOLDER=jctools
BALOK_FOLDER=balok

if [ -z $(which ant) ] && [ ! -e ${ANT_FOLDER} ]; then
    mkdir ${ANT_FOLDER}
    cd ${ANT_FOLDER}
    wget http://apache.cs.utah.edu//ant/binaries/apache-ant-1.10.5-bin.tar.gz
    tar -xzvf apache-ant-1.10.5-bin.tar.gz
    cd ..
fi

if [ -z $(which ant) ]; then
    export PATH="${PATH}:$(pwd)/${ANT_FOLDER}/apache-ant-1.10.5/bin"
fi

if [ ! -e ${JCTOOLS_FOLDER} ]; then
    mkdir ${JCTOOLS_FOLDER}
    #git clone https://github.com/JCTools/JCTools.git ${JCTOOLS_FOLDER}
    git clone https://github.com/franz1981/JCTools.git ${JCTOOLS_FOLDER}
fi
JCTOOLS_CORE_PATH=$(realpath ${JCTOOLS_FOLDER}/jctools-core)
if [ -z $(find ${JCTOOLS_CORE_PATH} -name "*.jar" | grep -P "jctools-core-\d+\.\d+-SNAPSHOT\.jar") ]; then
    cd ${JCTOOLS_FOLDER} && mvn install
    cd ..
fi

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
#cp ../../${JCTOOLS_FOLDER}/jctools-core/target/jctools-core-2.2-SNAPSHOT.jar .
JCTOOL_JAR=$(find ${JCTOOLS_CORE_PATH} -name "*.jar" | grep -P "jctools-core-\d+\.\d+-SNAPSHOT\.jar")
if [ -e ${JCTOOL_JAR} ]
then
    cp ${JCTOOL_JAR} ./jctools-core.jar
else
    echo "jctool-core.jar does not exist"
    exit 1
fi
pwd
ln -s ../../${BALOK_FOLDER}/build/libs/balok-1.0-dev-all-deps.jar balok-1.0-dev-all-deps.jar 
cd ..
ant
echo "Installation Completed"
