# OpenProject UfsAuth Plugin

Adds support for OmniAuth UfsAuth strategy for OpenProject.

## Usage
As user `openproject`...

Add this plugin by adding it to `/opt/openproject/Gemfile.custom`, e.g.:

```ruby
group :opf_plugins do
  gem 'omniauth-oauth2', git: 'https://github.com/omniauth/omniauth-oauth2', tag: 'v1.5.0'
  gem 'openproject-ufs_auth', :git => 'https://github.com/yasmimcc/openproject-ufs_auth.git'
end
```

Propagate the Gemfile to the package
```ruby
openproject config:set CUSTOM_PLUGIN_GEMFILE=/opt/openproject/Gemfile.custom
```

Put the following into a Rails initializer at `config/initializers/omniauth.rb`:
```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :ufs_auth, ENV['UFS_KEY'], ENV['UFS_SECRET']
end
```


Once you've done that install it via with user `su`

```ruby
openproject configure
```

If the plugin has been enabled you will have a new link that reads 'Ufs Auth' on the OpenProject login page and in the drop down menu.

Further details, check this old [video tutorial](https://www.youtube.com/watch?v=esCN9razZiE).
