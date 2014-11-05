nchc-puppet
==========

Following big data related open source peoject can be installed and configured using this puppet module. 
* hadoop (only support CDH)
* hbase  (only support CDH)
* zookeeper (only support CDH)
* storm (support apache storm and storm-on-yarn)

Quick start
--------------------
1. clone the github repo or download the latest release:
```sh
	git clone https://github.com/ogre0403/nchc-puppet.git
```
2. put package tar ball in corresponding folder
```sh
	cp hadoop-2.0.0-cdh4.0.0.tar.gz nchc-puppet/nchc/files/hadoop/tarball
	cp hbase-0.94.15-cdh4.7.0.tar.gz nchc-puppet/nchc/files/hbase/tarball
	cp  zookeeper-3.4.5-cdh4.7.0.tar.gz nchc-puppet/nchc/files/zookeeper/tarball
```
3. In /etc/puppet/manifests/site.pp, define:
```sh
	node '<hadoop hosts>' {
		include nchc::java::install
		include nchc::hadoop::install
		include nchc::hbase::install
		include nchc::zookeepr::install
	}
```
4. Parameters definition of each submoudle is defined in nchc-puppet/nchc/manifests/params 

Note: if formatNN is set to yes in nchc-puppet/nchc/manifests/params/hadoop.pp, the namenode will be formated. Please deploy hadoop slaves first, then deploy master node.


