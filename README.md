# Description

Puppet module to install and manage components of Cloudera's Distribution (CDH) for Apache Hadoop.

This repository works with CDH5.

Installs HDFS, YARN, Hive, Zookeeper and HBase.
Note that, in order for this module to work, you will have to ensure
that:

- Java version 7 or greater is installed
- Your package manager is configured with a repository containing the
  Cloudera 5 packages.

# Installation

Clone (or copy) this repository into your puppet modules/cdh directory:
```bash
git clone git://github.com/saivirtue/puppet_cdh.git modules/puppet_cdh
```

TODO : add installation guide (by hiera)