# /etc/puppet/modules/zookeeper/manafests/init.pp

class nchc::zookeeper::install ($server_id) {

    include nchc::zookeeper::package
    class { 'nchc::zookeeper::config':
        server_id => $server_id,
    }

}
