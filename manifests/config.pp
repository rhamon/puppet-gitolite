# Private class
class ogi_gitolite::config inherits ogi_gitolite {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  file { "${ogi_gitolite::home_dir}/admin.pub":
    ensure  => file,
    source  => $ogi_gitolite::admin_key_source,
    content => $ogi_gitolite::admin_key_content,
    owner   => $ogi_gitolite::user_name,
    group   => $ogi_gitolite::group_name,
    mode    => '0400',
  }->
  exec { "${ogi_gitolite::params::cmd_install} admin.pub":
    path        => [ '/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
    user        => $ogi_gitolite::user_name,
    cwd         => $ogi_gitolite::home_dir,
    environment => "HOME=${ogi_gitolite::home_dir}",
    creates     => "${ogi_gitolite::home_dir}/projects.list",
    before      => File[ "${ogi_gitolite::home_dir}/.gitolite.rc" ],
  }

  file { "${ogi_gitolite::home_dir}/.gitolite.rc":
    ensure  => file,
    content => template("${module_name}/gitolite${ogi_gitolite::version}.rc.erb"),
    owner   => $ogi_gitolite::user_name,
    group   => $ogi_gitolite::group_name,
  }
}
