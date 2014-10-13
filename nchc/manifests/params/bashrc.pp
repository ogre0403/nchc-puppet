#/etc/puppet/modules/nchc/manifests/params/storm.pp

class nchc::params::bashrc (
    $user = "hdadm",
    $group = "hdadm"
)
{
    include nchc::params::java
    include nchc::params::maven
    include nchc::params::hadoop
    include nchc::params::hbase
    include nchc::params::zookeeper
    include nchc::params::storm

    $bashrc_template = $operatingsystem ? {
      centos                => 'nchc/home/rh_bashrc.erb',
      redhat                => 'nchc/home/rh_bashrc.erb',
      /(?i)(ubuntu|debian)/ => 'nchc/home/debian_bashrc.erb',
      default               => 'nchc/home/rh_bashrc.erb',
    }


    file { "set environment var in .bashrc":
        path => "/home/${user}/.bashrc",
        ensure => present,
        owner => "${user}",
        group => "${group}",
        content => template("$bashrc_template"),
    }

}
