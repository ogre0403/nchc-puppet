# /etc/puppet/modules/java/manifests/params.pp

class nchc::params::zookeeper {

        $java_version = $::hostname ? {
            default	=> "1.7.0_51",
        }
        $java_base = $::hostname ? {
            default     => "/opt/java_version",
        }
        $java_current = $::hostname ? {
            default     => "/opt/java",
        }
        $jdk_url = $::hostname ? {
            default => "http://download.oracle.com/otn-pub/java/jdk/7u51-b13/jdk-7u51-linux-x64.tar.gz",
        }
}
