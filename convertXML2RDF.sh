#!/bin/bash

# Source data: http://eplca.jrc.ec.europa.eu/ELCD3/datasetDownload.xhtml

if [ ! -f ELCDIII_1.zip ]; then
	wget http://eplca.jrc.ec.europa.eu/ELCD3/downloads/datasets/ELCDIII_1.zip
fi

unzip ELCDIII_1.zip

rm -rf ./RDF
mkdir RDF

# There's a huge number of files and we want to be able to run multiple xslt transforms in parallel
# This bash script does a simple check for the number of running instances and starts up more
# if the number of instances is less than the number of cores specified
numCores=8

files=`find ./ILCD/flows/ -name "*.xml"`
for file in $files
do

	while [ $(ps -ef | grep -v grep | grep saxonb | wc -l) -ge $numCores ];
	do
		sleep 0.001
	done

        rdfFile=`echo $file | grep -oe "[a-z0-9-]\+.xml" | sed 's/.xml/.rdf/g'`
        echo $rdfFile

	saxonb-xslt -o ./RDF/$rdfFile $file ILCD_Flow.xsl &
done

files=`find ./ILCD/processes/ -name "*.xml"`
for file in $files
do

        while [ $(ps -ef | grep -v grep | grep saxonb | wc -l) -ge $numCores ];
        do
                sleep 0.001
        done

        rdfFile=`echo $file | grep -oe "[a-z0-9-]\+.xml" | sed 's/.xml/.rdf/g'`
        echo $rdfFile
	saxonb-xslt -o ./RDF/$rdfFile $file ILCD_Process.xsl &
done

cd RDF
tar -czvf ../ILCD.tar.gz *.rdf
cd ..
rm -rf ./RDF
