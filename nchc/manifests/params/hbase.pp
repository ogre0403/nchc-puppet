# /etc/puppet/modules/nchc-hbase/manafests/params.pp

class nchc::params::hbase {

    $hbase_adm =  "hdadm"
    $hbase_grp = "hdadm" 
    $hbase_jdk = "/opt/java"
    $hbase_hdfs =  "NN-agent"
    $hbase_hdfsport = "9000"
    $hbase_version = "hbase-0.94.15-cdh4.7.0"
    $hbase_base =  "/opt/hbase_version"
    $hbase_current = "/opt/hbase"
    $hbase_master = ["NN-agent"]
    $hbase_regionservers = ["DN1-agent"]
    $zookeeper_quorum = ["NN-agent"]
    $hbase_dir = "hbase"
    $rs_heap = "8192"
    $hadoop_conf_path = "/opt/hadoop/etc/hadoop"
}
