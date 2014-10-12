#/etc/puppet/modules/NCHC/manifests/storm/storm.pp

class nchc::storm::install {
    include nchc::storm::package
    include nchc::storm::config
}
