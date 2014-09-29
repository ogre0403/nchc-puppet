# /etc/puppet/modules/vagrant_base/manifests/init.pp

class vagrant_base(
        $user = 'vagrant', 
        $group = 'vagrant', 
    ) {

    user { "${user}":
        ensure     => "present",
        managehome => true,
        shell  => "/bin/bash",
    }

	package { ["vim", "screen"]:
		ensure => installed,
	}

    file { "/home/${user}/.screenrc":
        ensure => present,
        owner => $user,
        group => $group,
        alias => "screen-config",
        source => "puppet:///modules/vagrant_base/screenrc",
        require => [Package["screen"], User["${user}"]],
    }

    file { "/home/${user}/.vimrc":
        ensure => present,
        owner => $user,
        group => $group,
        alias => "vim-config",
        source => "puppet:///modules/vagrant_base/vimrc",
        require => [Package["vim"], User["${user}"]],
    }

    file { "/home/${user}/.bashrc":
        ensure => present,
        owner => $user,
        group => $group,
        alias => "bashrc",
        source => "puppet:///modules/vagrant_base/bashrc",
        require => User["${user}"],
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
        source => "puppet:///modules/vagrant_base/molokai.vim",
        require => File["vim-color-dir"],
    }
}
