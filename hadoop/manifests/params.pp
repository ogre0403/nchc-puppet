#/etc/puppet/modules/hadoop/manifests/params.pp

class hadoop::params{

    $hdadm = $::hostname ? {
        default => "hdadm",
    }

    $hdgrp = $::hostname ? {
        default => "hdadm",
    }


    $disable_auto_ssh = $::hostname ? {
        default => "false",
    }
}
