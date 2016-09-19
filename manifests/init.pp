class ogi_gitolite (
  $admin_key_content   = undef,
  $admin_key_source    = undef,
  $allow_local_code    = $ogi_gitolite::params::allow_local_code,
  $git_config_keys     = $ogi_gitolite::params::git_config_keys,
  $group_name          = $ogi_gitolite::params::group_name,
  $home_dir            = $ogi_gitolite::params::home_dir,
  $local_code_in_repo  = $ogi_gitolite::params::local_code_in_repo,
  $local_code_path     = $ogi_gitolite::params::local_code_path,
  $manage_home_dir     = $ogi_gitolite::params::manage_home_dir,
  $manage_user         = $ogi_gitolite::params::manage_user,
  $package_ensure      = $ogi_gitolite::params::package_ensure,
  $package_name        = $ogi_gitolite::params::package_name,
  $repo_specific_hooks = $ogi_gitolite::params::repo_specific_hooks,
  $umask               = $ogi_gitolite::params::umask,
  $user_name           = $ogi_gitolite::params::user_name,
  $version             = $ogi_gitolite::params::version,
) inherits ogi_gitolite::params {
  validate_string($package_ensure)
  validate_string($package_name)
  validate_re($version, ['2', '3'])
  validate_string($user_name)
  validate_string($group_name)
  validate_absolute_path($home_dir)
  validate_bool($manage_home_dir)
  validate_bool($manage_user)

  if $admin_key_source and $admin_key_content {
    fail 'Parameters `admin_key_source` and `admin_key_content` are mutually exclusive'
  }
  if $admin_key_source {
    validate_string($admin_key_source)
  }
  if $admin_key_content {
    validate_string($admin_key_content)
  }

  validate_string($git_config_keys)
  validate_re($umask, '^0[0-7][0-7][0-7]$')
  validate_bool($allow_local_code)
  validate_bool($local_code_in_repo)
  validate_string($local_code_path)
  if $local_code_in_repo and ! $allow_local_code {
    fail 'Parameter `allow_local_code` must be true to enable `local_code_in_repo`'
  }
  validate_bool($repo_specific_hooks)

  anchor { "${module_name}::begin": } ->
  class { "${module_name}::install": } ->
  class { "${module_name}::config": } ->
  anchor { "${module_name}::end": }
}
