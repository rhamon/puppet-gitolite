# Private class
class ogi_gitolite::install inherits ogi_gitolite {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $ogi_gitolite::manage_user {
    group { $ogi_gitolite::group_name:
      ensure => 'present',
      system => true,
    }->
    user { $ogi_gitolite::user_name:
      ensure           => 'present',
      gid              => $ogi_gitolite::group_name,
      home             => $ogi_gitolite::home_dir,
      password         => '*',
      password_max_age => '99999',
      password_min_age => '0',
      shell            => '/bin/sh',
      system           => true,
      before           => File[$ogi_gitolite::home_dir],
    }
  }

  if $ogi_gitolite::manage_home_dir {
    file { $ogi_gitolite::home_dir:
      ensure => directory,
      owner  => $ogi_gitolite::user_name,
      group  => $ogi_gitolite::group_name,
      before => Package[$ogi_gitolite::package_name],
    }
  }

  package { $ogi_gitolite::package_name:
    ensure => $ogi_gitolite::package_ensure,
    alias  => 'gitolite',
  }
}
