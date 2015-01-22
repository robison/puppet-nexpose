# Class: nexpose

class nexpose (
  $port                 = $::nexpose::params::port,
  $server_root          = $::nexpose::params::server_root,
  $doc_root             = $::nexpose::params::doc_root,
  $min_server_threads   = $::nexpose::params::min_server_threads,
  $max_server_threads   = $::nexpose::params::max_server_threads,
  $keepalive            = $::nexpose::params::keepalive,
  $socket_timeout       = $::nexpose::params::socket_timeout,
  $sc_lookup_cache_size = $::nexpose::params::sc_lookup_cache_size,
  $debug                = $::nexpose::params::debug,
  $httpd_error_strings  = $::nexpose::params::httpd_error_strings,
  $default_start_page   = $::nexpose::params::default_start_page,
  $default_login_page   = $::nexpose::params::default_login_page,
  $default_home_page    = $::nexpose::params::default_home_page,
  $default_setup_page   = $::nexpose::params::default_setup_page,
  $default_error_page   = $::nexpose::params::default_error_page,
  $first_time_config    = $::nexpose::params::first_time_config,
  $bad_login_lockout    = $::nexpose::params::bad_login_lockout,
  $admin_app_path       = $::nexpose::params::admin_app_path,
  $auth_param_username  = $::nexpose::params::auth_param_username,
  $auth_param_password  = $::nexpose::params::auth_param_password,
  $server_id_string     = $::nexpose::params::server_id_string,
  $proglet_list         = $::nexpose::params::proglet_list,
  $taglib_list          = $::nexpose::params::taglib_list,
  $virtualhost          = $::nexpose::params::virtualhost,
  $api_user             = $::nexpose::params::api_user,
  $api_password         = $::nexpose::params::api_password,
  $linuxinstaller       = $::nexpose::params::linuxinstaller,
  $windowsinstaller     = $::nexpose::params::windowsinstaller,
  $first_name           = $::nexpose::params::first_name,
  $last_name            = $::nexpose::params::last_name,
  $company_name         = $::nexpose::params::company_name,
  $install_typical      = $::nexpose::params::install_typical,
  $install_engine       = $::nexpose::params::install_engine,
  $installer_path       = $::nexpose::params::installer_path,
  $init_service         = $::nexpose::params::init_service,
  $suppress_reboot      = $::nexpose::params::suppress_reboot,
  ) inherits nexpose::params {
  
  include 'nexpose::install'
  include 'nexpose::config'
  include 'nexpose::service'

  Class['nexpose::install'] -> Class['nexpose::config'] -> Class['nexpose::service']

}
