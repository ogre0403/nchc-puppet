# /etc/puppet/modules/vagrant_base/manifests/init.pp

class nchc::base::install(
        $user = 'hdadm', 
        $group = 'hdadm',
        $password = 'hadoop',
    ) {



    user { "${user}":
        ensure     => "present",
        managehome => true,
        shell  => "/bin/bash",
        password => generate('/bin/sh', '-c', "mkpasswd -m sha-512 ${password} | tr -d '\n'"),
    }
 
    $vim = $operatingsystem ? {
      centos                => 'vim-enhanced.x86_64',
      redhat                => 'vim-enhanced.x86_64',
      /(?i)(ubuntu|debian)/ => 'vim',
      default               => undef,
    }

    $screen = $operatingsystem ? {
      centos                => 'screen.x86_64',
      redhat                => 'screen.x86_64',
      /(?i)(ubuntu|debian)/ => 'screen',
      default               => undef,
    }

	package { ["${vim}", "${screen}"]:
		ensure => installed,
	}

    file { "/home/${user}/.screenrc":
        ensure => present,
        owner => $user,
        group => $group,
        alias => "screen-config",
        source => "puppet:///modules/nchc/base/screenrc",
        require => [Package["${screen}"], User["${user}"]],
    }

    file { "/home/${user}/.vimrc":
        ensure => present,
        owner => $user,
        group => $group,
        alias => "vim-config",
        source => "puppet:///modules/nchc/base/vimrc",
        require => [Package["${vim}"], User["${user}"]],
    }


    file { "/home/${user}/.vim":
        ensure => "directory",
        owner => $user,
        group => $group,
        alias => "vim-dir",
        require => User["${user}"],
    }
    
    file { "/home/${user}/.vim/colors":
        ensure => "directory",
        owner => $user,
        group => $group,
        alias => "vim-color-dir",
        require => File["vim-dir"],
    }

    file { "/home/${user}/.vim/colors/molokai.vim":
        ensure => present,
        owner => $user,
        group => $group,
        source => "puppet:///modules/nchc/base/molokai.vim",
        require => File["vim-color-dir"],
    }
}
