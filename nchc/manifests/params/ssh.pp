#/etc/puppet/modules/nchc/manifests/params/storm.pp

class nchc::params::ssh {

    $user = $::hostname ? {
        default => "vagrant",
    }          

    $group = $::hostname ? {
        default => "vagrant",
    }          

    $auto_login = $::hostname ? {
        default => "true",
    }          

    $pubkey = $::hostname ? {
        default => "AAAAB3NzaC1yc2EAAAADAQABAAABAQDdjqZ5xLoREqHkzszikDtyecUJQdVaeuAKkjx4iU6/g8USVL+495mCmP5WXtIBYFRYiwXhNiiInrxTQ9NZ5qmDuxxRMPm04H0vfk2y/Lo/GI5GbYiuvui+U1daxbn6KZ0jEpVddwzX4qTlmNvYnA2G9G1In4HXCCE7rWd8LdU0gKrLbhOkWVzzkcMXb/4XCdOgLvlLl+qUSH6D3I8I8kGduzWIEKGelMJmrowiAmsu7iIIReUtOHoAy2jjV9V2931SRhOlMYaqgyARjLcA3sjPrBZ0/5jQu0eH1CnU2S6A7IirAxDpsNp+eggW266K8jhIJnzVK1gPJTKlpdlr4Pff",
    }          
    
}
