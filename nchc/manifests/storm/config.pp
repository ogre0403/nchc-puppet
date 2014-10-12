#/etc/puppet/modules/NCHC/manifests/storm/storm.pp

class nchc::storm::config {

    include nchc::params::storm


    exec { "mkdir ${nchc::params::storm::storm_local_dir}":
        command => "mkdir -p ${nchc::params::storm::storm_local_dir}",
        cwd => "${nchc::params::storm::storm_base}/",
        alias => "create-storm-local-dir",
        path   => ["/bin", "/usr/bin", "/usr/sbin"],
        onlyif => "test ! -d ${nchc::params::storm::storm_local_dir}",
        require => File["storm-app-dir"],
    }

    file { "${nchc::params::storm::storm_local_dir}":
        ensure => "directory",
        owner => "${nchc::params::storm::storm_adm}",
        group => "${nchc::params::storm::storm_grp}",
        alias => "storm-local-dir",
        require => Exec["create-storm-local-dir"],
    }

    file { "${nchc::params::storm::storm_base}/${nchc::params::storm::storm_version}/conf/storm.yaml":
        owner => "${nchc::params::storm::storm_adm}",
        group => "${nchc::params::storm::storm_grp}",
        alias => "storm-yaml",
        require => File["storm-app-dir"],
        content => template("nchc/storm/storm.yaml.erb"),
    }


}
