# == Class puppet-cdh::cdh5::hadoop::namenode::primary
# Hadoop Primary NameNode.
#
# This class is applied by puppet-cdh::cdh5::hadoop::master even
# if we aren't using HA Standby Namenodes.  The primary NameNode will be inferred
# as the first entry $puppet-cdh::cdh5::hadoop::namenode_hosts variable.  If we are using
# HA, then the primary NameNode will be transitioned to active as once NameNode
# has been formatted, before common HDFS directories are created.
#
class puppet-cdh::cdh5::hadoop::namenode::primary inherits puppet-cdh::cdh5::hadoop::namenode {
    # Go ahead and transision this primary namenode to active if we are using HA.
    if ($::puppet-cdh::cdh5::hadoop::ha_enabled) {
        $primary_namenode_id = $::puppet-cdh::cdh5::hadoop::primary_namenode_id

        exec { 'haaadmin-transitionToActive':
            # $namenode_id is set in parent puppet-cdh::cdh5::hadoop::namenode class.
            command     => "/usr/bin/hdfs haadmin -transitionToActive ${primary_namenode_id}",
            unless      => "/usr/bin/hdfs haadmin -getServiceState    ${primary_namenode_id} | /bin/grep -q active",
            user        => 'hdfs',
            # Only run this command if the namenode was just formatted
            # and after the namenode has started up.
            refreshonly => true,
            subscribe   => Exec['hadoop-namenode-format'],
            require     => Service['hadoop-hdfs-namenode'],
        }
        # Make sure NameNode is running and active
        # before we try to create common HDFS directories.
        puppet-cdh::Cdh5::Hadoop::Directory {
            require => Exec['haaadmin-transitionToActive'],
        }
    }
    else {
        # Make sure NameNode is running
        # before we try to create common HDFS directories.
        puppet-cdh::Cdh5::Hadoop::Directory {
            require =>  Service['hadoop-hdfs-namenode'],
        }
    }

    # Create common HDFS directories.

    # sudo -u hdfs hdfs dfs -mkdir /tmp
    # sudo -u hdfs hdfs dfs -chmod 1777 /tmp
    puppet-cdh::cdh5::hadoop::directory { '/tmp':
        owner => 'hdfs',
        group => 'hdfs',
        mode  => '1777',
    }

    # sudo -u hdfs hdfs dfs -mkdir /user
    # sudo -u hdfs hdfs dfs -chmod 0775 /user
    # sudo -u hdfs hdfs dfs -chown hdfs:hadoop /user
    puppet-cdh::cdh5::hadoop::directory { '/user':
        owner => 'hdfs',
        group => 'hadoop',
        mode  => '0775',
    }

    # sudo -u hdfs hdfs dfs -mkdir /user/hdfs
    puppet-cdh::cdh5::hadoop::directory { '/user/hdfs':
        owner   => 'hdfs',
        group   => 'hdfs',
        mode    => '0755',
        require => puppet-cdh::Cdh5::Hadoop::Directory['/user'],
    }

    # sudo -u hdfs hdfs dfs -mkdir /var
    puppet-cdh::cdh5::hadoop::directory { '/var':
        owner => 'hdfs',
        group => 'hdfs',
        mode  => '0755',
    }

    # sudo -u hdfs hdfs dfs -mkdir /var/lib
    puppet-cdh::cdh5::hadoop::directory { '/var/lib':
        owner   => 'hdfs',
        group   => 'hdfs',
        mode    => '0755',
        require => puppet-cdh::Cdh5::Hadoop::Directory['/var'],
    }

    # sudo -u hdfs hdfs dfs -mkdir /var/log
    puppet-cdh::cdh5::hadoop::directory { '/var/log':
        owner   => 'hdfs',
        group   => 'hdfs',
        mode    => '0755',
        require => puppet-cdh::Cdh5::Hadoop::Directory['/var'],
    }
}
