# ILCD-to-RDF
Converts LCA data in an ILCD XML serialization to a (roughly equivalent) RDF/XML serialization

The ILCD schema is quite large, and this code converts only a very small subset which is sufficient for representing the inputs and outputs flows of processes.  The main motivation for this is to explore opportunites and issues with Linked Data and LCA.

# Dependencies:
You need to have saxonb-xslt installed:

```sudo apt-get install libsaxonb-java```

# Running
The bash script downloads and processes (in parallel) the [ELCD3 dataset](http://eplca.jrc.ec.europa.eu/ELCD3/datasetDownload.xhtml).  You may want to change the ```numCores``` variable based on your CPU.

```bash ./convertXML2RDF.sh```

# Improvements
* The code could probably be sped up by first appending contents of the process and flow xml files into two main files.  Right now the files are so small and the processing time is so quick that the CPU is hardly fully utilized even with multiple XSLT transformations running at the same time.   
