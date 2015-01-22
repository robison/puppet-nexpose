# Class: nexpose::service
class nexpose::service inherits nexpose::params {
  
  service {
    'nexposeconsole.rc':
      ensure  => running,
      enable  => true,
  }
  
}