# /etc/puppet/modules/java/manifests/params.pp

class nchc::params::java {

        $java_source = $::hostname ? {
            default	=> "jdk-7u71-linux-x64.tar.gz",
        }
        $java_version = $::hostname ? {
            default	=> "jdk1.7.0_71",
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
