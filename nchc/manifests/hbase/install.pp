# /etc/puppet/modules/zookeeper/manafests/init.pp

class nchc::hbase::install {
    include nchc::hbase::package
    include nchc::hbase::config

}
