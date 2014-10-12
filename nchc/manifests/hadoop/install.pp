#/etc/puppet/modules/hadoop/manifests/uninstall.pp

class nchc::hadoop::install{
    include nchc::hadoop::package
    include nchc::hadoop::config

}
