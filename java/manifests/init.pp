# /etc/puppet/modules/java/manifests/init.pp

class java ( $uninstall = 'false', ){
    if $uninstall == 'false' {
        require java::install
    }
    elsif $uninstall == 'true'{
        require java::uninstall
    }
}
