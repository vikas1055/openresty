class openresty
{
#1: Dependency Packages 
# For RHEL- 6
###############
$depes_package = [ "gcc", "pcre-devel", "openssl-devel", "openssl","curl", "readline-devel" ]
package { $depes_package: }

->
# PCRE 8.41 Installation for pcre-jit support
file     { "/opt/pcre-8.41.tar.gz":
         ensure   => present,
         owner => "root",
         group => "root",
         mode => 0644,
         source => "puppet://$puppetserver/modules/openresty/pcre-8.41.tar.gz",
        }
->
exec  {"untar-pcre":
        cwd     => "/opt",
        command => "tar -zxvf pcre-8.41.tar.gz",
        provider => 'shell',
        path => [ "/bin", "/usr/bin" ],
        require => [File [ "/opt/pcre-8.41.tar.gz"] ],
        }
->
## Now openresty Installation Start
file 	 { "/opt/openresty-1.11.2.5.tar.gz":
         ensure   => present,
	 owner => "root",
         group => "root",
         mode => 0644,
         source => "puppet://$puppetserver/modules/openresty/openresty-1.11.2.5.tar.gz",
        }
->
exec  {"untar-openresty":
        cwd     => "/opt",
        command => "tar -zxvf openresty-1.11.2.5.tar.gz",
	provider => 'shell',
	path => [ "/bin", "/usr/bin" ],
        require => [File [ "/opt/openresty-1.11.2.5.tar.gz"] ],
        unless  => "find /usr/local/ | grep openresty",
	before => Exec ["configure-openresty"],
      }
->
exec { 'configure-openresty':
	cwd	=> "/opt/openresty-1.11.2.5",
	command	=> './configure --prefix=/usr/local/openresty --with-pcre=/opt/pcre-8.41/ --with-pcre-jit --with-luajit --with-http_ssl_module',
        provider => 'shell',
        path => [ "/bin", "/usr/bin" ],
        unless    => 'find /usr/local/ | grep openresty',
        before => Exec ["make-openresty"],
     }
->
exec { 'make-openresty':
        cwd     => "/opt/openresty-1.11.2.5",
        command   => 'make',
        provider => 'shell',
        path => [ "/bin", "/usr/bin" ],
        unless    => 'find /usr/local/ | grep openresty',
        before => Exec ["make-install-openresty"],
     }
->
exec { 'make-install-openresty':
        cwd     => "/opt/openresty-1.11.2.5",
        command   => 'make install',
        provider => 'shell',
        path => [ "/bin", "/usr/bin" ],
        unless    => 'find /usr/local/ | grep openresty',
     }

#Initialise the init script  service 
->
file     { "/etc/init.d/nginx":
         ensure   => present,
         owner => "root",
         group => "root",
         mode => 0755,
         source => "puppet://$puppetserver/modules/openresty/nginx",
        }
# Ensure service running
->
service { 'nginx':
    ensure => 'running',
  }


}

