# Class: nexpose::params

class nexpose::params {

  #install options
  $linuxinstaller        = 'NeXposeSetup-Linux64.bin'
  $windowsinstaller      = 'NeXposeSetup-Windows64.exe'
  $first_name            = 'NeXpose'
  $last_name             = 'User'
  $company_name          = 'Rapid7'
  $auth_param_username   = 'nexposeccusername'
  $auth_param_password   = 'nexposeccpassword'
  $install_typical       = false
  $install_engine        = true
  $init_service          = true
  $suppress_reboot       = true

  #web server config
  $port                  = 3780
  $server_root           = '.'
  $doc_root              = 'htroot'
  $min_server_threads    = 10
  $max_server_threads    = 100
  $keepalive             = false
  $socket_timeout        = 10000
  $sc_lookup_cache_size  = 100
  $debug                 = 10
  $httpd_error_strings   = 'conf/httpErrorStrings.properties'
  $default_start_page    = '/starting.html'
  $default_login_page    = '/login.html'
  $default_home_page     = '/home.jsp'
  $default_setup_page    = '/setup.html'
  $default_error_page    = '/error.html'
  $first_time_config     = false
  $bad_login_lockout     = 4
  $admin_app_path        = '/admin/global'
  $server_id_string      = 'NSC/0.6.4 (JVM)'
  $proglet_list          = 'conf/proglet.xml'
  $taglib_list           = 'conf/taglibs.xml'
  $virtualhost           = $::fqdn

  #ldap
  $ldap_name             = 'ldap'
  $ldap_server           = undef
  $ldap_port             = 636
  $ldap_ssl              = true
  $ldap_base             = undef
  $ldap_follow_referrals = true
  $ldap_email_map        = 'mail'
  $ldap_login_map        = 'sAMAccountName'
  $ldap_fullname_map     = 'cn'

  #api
  $api_user              = 'nxadmin'
  $api_password          = 'nxpassword'
  
}
