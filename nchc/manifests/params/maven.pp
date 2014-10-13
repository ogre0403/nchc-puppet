# /etc/puppet/modules/java/manifests/params.pp

class nchc::params::maven {

        $mvn_version = $::hostname ? {
            default	=> "apache-maven-3.1.0",
        }
        $mvn_base = $::hostname ? {
            default     => "/opt/maven_version",
        }
        $mvn_current = $::hostname ? {
            default     => "/opt/maven",
        }
}
