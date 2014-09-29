# /etc/puppet/modules/vagrant_base/manifests/init.pp

class vagrant_base {
	package { ["vim", "screen"]:
		ensure => installed,
	}

    file { "/home/vagrant/.screenrc":
        ensure => present,
        owner => "vagrant",
        group => "vagrant",
        alias => "screen-config",
        source => "puppet:///modules/vagrant_base/screenrc",
        require => Package["screen"],
    }

    file { "/home/vagrant/.vimrc":
        ensure => present,
        owner => "vagrant",
        group => "vagrant",
        alias => "vim-config",
        source => "puppet:///modules/vagrant_base/vimrc",
        require => Package["vim"],
    }

    file { "/home/vagrant/.bashrc":
        ensure => present,
        owner => "vagrant",
        group => "vagrant",
        alias => "bashrc",
        source => "puppet:///modules/vagrant_base/bashrc",
    }

    file { "/home/vagrant/.vim":
        ensure => "directory",
        owner => "vagrant",
        group => "vagrant",
        alias => "vim-dir",
    }
    
    file { "/home/vagrant/.vim/colors":
        ensure => "directory",
        owner => "vagrant",
        group => "vagrant",
        alias => "vim-color-dir",
        require => File["vim-dir"],
    }

    file { "/home/vagrant/.vim/colors/molokai.vim":
        ensure => present,
        owner => "vagrant",
        group => "vagrant",
        source => "puppet:///modules/vagrant_base/molokai.vim",
        require => File["vim-color-dir"],
    }
}
