set :rails_env, 'production'

$:.unshift(File.expand_path('./lib', ENV['rvm_path']))

set :rvm_install_ruby_params, '--verify-downloads 1'
set :rvm_type, :user
set :branch, 'master'

#default_run_option[:pty] = true
ssh_options[:forward_agent] = true

#server 'APP_NAME.production.tworedkites.com', :web, :app, :db, primary: true
