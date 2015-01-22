# Class: nexpose::service

class nexpose::service (
  
  $install_console = $::nexpose::install_console,
  $install_engine  = $::nexpose::install_engine,

  ) inherits nexpose::params {
  
  if $install_console {
    service {
      'nexposeconsole.rc':
        ensure => running,
        enable => true,
      }
    }

  if $install_engine {
    service {
      'nexposeengine.rc':
        ensure => running,
        enable => true,
    }
  }
}