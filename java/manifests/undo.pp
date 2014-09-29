class java::nudo{
    file {'remove_directory':
    ensure => absent,
    path => '/opt/java_version',
    recurse => true,
    purge => true,
    force => true,
   }

}
