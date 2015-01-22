# Class: nexpose::config

class nexpose::config (

  $port                 = $::nexpose::port,
  $scan_engine_port     = $::nexpose::scan_engine_port,
  $server_root          = $::nexpose::server_root,
  $doc_root             = $::nexpose::doc_root,
  $min_server_threads   = $::nexpose::min_server_threads,
  $max_server_threads   = $::nexpose::max_server_threads,
  $keepalive            = $::nexpose::keepalive,
  $socket_timeout       = $::nexpose::socket_timeout,
  $sc_lookup_cache_size = $::nexpose::sc_lookup_cache_size,
  $debug                = $::nexpose::debug,
  $httpd_error_strings  = $::nexpose::httpd_error_strings,
  $default_start_page   = $::nexpose::default_start_page,
  $default_login_page   = $::nexpose::default_login_page,
  $default_home_page    = $::nexpose::default_home_page,
  $default_setup_page   = $::nexpose::default_setup_page,
  $default_error_page   = $::nexpose::default_error_page,
  $first_time_config    = $::nexpose::first_time_config,
  $bad_login_lockout    = $::nexpose::bad_login_lockout,
  $admin_app_path       = $::nexpose::admin_app_path,
  $auth_param_username  = $::nexpose::auth_param_username,
  $auth_param_password  = $::nexpose::auth_param_password,
  $server_id_string     = $::nexpose::server_id_string,
  $proglet_list         = $::nexpose::proglet_list,
  $taglib_list          = $::nexpose::taglib_list,
  $virtualhost          = $::nexpose::virtualhost,
  $api_user             = $::nexpose::api_user,
  $api_password         = $::nexpose::api_password,
  $install_console      = $::nexpose::install_console,
  $install_engine       = $::nexpose::install_engine,
  
  ) inherits nexpose::params {

  file {
    '/opt/rapid7/nexpose/nsc/conf/httpd.xml':
      notify  => Service['nexposeconsole.rc'],
      content => template('nexpose/httpd.xml.erb');
    '/opt/rapid7/nexpose/nsc/conf/api.conf':
      content => "user=${api_user}\npassword=${api_password}\nserver=${virtualhost}\nport=${port}\n",
      mode    => '0400';
  }

  if $install_console {
    augeas {
      '/opt/rapid7/nexpose/nsc/conf/nsc.xml':
        context => '/files/opt/rapid7/nexpose/nsc/conf/nsc.xml/NeXposeSecurityConsole',
        incl    => '/opt/rapid7/nexpose/nsc/conf/nsc.xml',
        lens    => 'Xml.lns',
        changes => [
          "set WebServer/#attribute/port ${port}",
          "set WebServer/#attribute/minThreads ${min_server_threads}",
          "set WebServer/#attribute/maxThreads ${max_server_threads}",
          "set WebServer/#attribute/failureLockout ${bad_login_lockout}",
          ],
        notify  => Service['nexposeconsole.rc'],
        user    => root;
    }
    exec { 'open_webserver_port':
      command => "/sbin/iptables -I INPUT 5 -m state --state NEW -p tcp --dport ${port} -j ACCEPT",
      user    => root,
    }
  }

  if $install_engine {
    augeas {
      '/opt/rapid7/nexpose/nse/conf/nse.xml':
        context => '/files/opt/rapid7/nexpose/nse/conf/nse.xml/NeXposeScanEngine',
        incl    => '/opt/rapid7/nexpose/nse/conf/nse.xml',
        lens    => 'Xml.lns',
        changes => [
          "set NeXposeScanEngine/#attribute/port ${scan_engine_port}",
          ],
        notify  => Service['nexposeconsole.rc'],
        user    => root;
    }
    exec { 'open_sconsole_port':
      command => "/sbin/iptables -I INPUT 5 -m state --state NEW -p tcp --dport ${scan_engine_port} -j ACCEPT",
      user    => root,
    }
  }

  user {'nexpose':
    password => '!';
  }

}