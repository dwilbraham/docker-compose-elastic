# docker-compose-elastic

[Docker Compose](https://docs.docker.com/compose/) configuration and scripts for experimenting with [elasticsearch](https://www.elastic.co/) and [kibana](https://www.elastic.co/products/kibana).

To run elasticsearch and kibana run:
```bash
docker-compose up -d
```

To validate that elasticsearch started correctly run:
```bash
es=`bin/service_address.sh elasticsearch 9200`
curl $es/
curl $es/_cluster/state?pretty
```

This setup and the example scripts should be compatible with any of the following scenarios:
- Local Docker instance
- Remote [Docker Machine](https://docs.docker.com/machine/) instance
- Remote [Docker Swarm](https://docs.docker.com/swarm/) cluster

To play with some example data try one of the following:

### Wikipedia search:

Following an elastic blog on [loading wikipedia search data into elastic](https://www.elastic.co/blog/loading-wikipedia).

As explained in the blog post choose and download a dump of one of the wikimedia sites from [here](https://dumps.wikimedia.org/other/cirrussearch/) (these instructions assume you use the enwikiquote content dump).

Install the required plugin into elastic (and the sense plugin for kibana because it is very useful):

```bash
bin/install_plugins.sh
```

Setup the elastic index with the correct mappings and load the dump in (the first part of the index reset will fail as it doesn't exist yet, this is expected and isn't a problem):

```bash
bin/reset_wiki_index.sh
bin/load_wiki_dump.sh PATH_TO_DUMP_FILE
```

If you are using firefox you can view your new index in kibana by running ```bin/firefox_kibana.sh``` and setting up searching of a new index called ```enwikiquote```.

If you want to experiment with some other wikimedia dump files the above scripts accept arguments to change the index type and name.

### UK roadworks:

An example index to search a history of UK roadworks from [data.gov.uk](https://data.gov.uk/data/api/transport).

To create (or reset) the index and it's mappings run the following command:

```bash
bin/reset_roadworks_index.sh
```

To load data into the index for a given UK road run the following for as many different roads as you want data for (swap M1 for whichever UK road you are interested in):

```bash
bin/load_roadworks_data.sh M1
```

If you are using firefox you can view your new index in kibana by running ```bin/firefox_kibana.sh``` and setting up searching of a new index called ```roadworks```.

> Written with [StackEdit](https://stackedit.io/).
