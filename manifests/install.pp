# vim:ft=ruby
# Class: nexpose::install

class nexpose::install (

  $first_name          = $nexpose::first_name,
  $last_name           = $nexpose::last_name,
  $company_name        = $nexpose::company_name,
  $auth_param_username = $nexpose::auth_param_username,
  $auth_param_password = $nexpose::auth_param_password,
  $install_console     = $nexpose::install_console,
  $install_engine      = $nexpose::install_engine,
  $installer_path      = $nexpose::installer_path,
  $init_service        = $nexpose::init_service,
  $suppress_reboot     = $nexpose::suppress_reboot,
  $linuxinstaller      = $nexpose::linuxinstaller,
  $windowsinstaller    = $nexpose::windowsinstaller,

  ) inherits nexpose::params {
  
  if $install_console {
    $sys_component_typical = 'True'
  } else {
    $sys_component_typical = 'False'
  }

  if $install_engine {
    $sys_component_engine = 'True'
  } else {
    $sys_component_engine = 'False'
  }
  
  exec { 'install_nexpose':
    command => "${installer_path}${linuxinstaller} -q -overwrite -Vfirstname='${first_name}' -Vlastname='${last_name}' -Vcompany='${company_name}' -Vusername='${auth_param_username}' -Vpassword1='${auth_param_password}' -Vpassword2='${auth_param_password}' -Vsys.component.typical\$Boolean=${sys_component_typical} -Vsys.component.engine\$Boolean=${sys_component_engine} -VinitService\$Boolean=${init_service} -Dinstall4j.suppressUnattendedReboot=${suppress_reboot}",
    creates => '/opt/rapid7/nexpose/nsc/nsc.sh',
    user    => root,
  }

}
