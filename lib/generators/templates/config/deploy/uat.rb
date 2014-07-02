set :rails_env, 'uat'

$:.unshift(File.expand_path('./lib', ENV['rvm_path']))

set :rvm_install_ruby_params, '--verify-downloads 1'
set :rvm_type, :user
set :branch, 'develop'

#default_run_option[:pty] = true
ssh_options[:forward_agent] = true

#server 'APP_NAME.uat.tworedkites.com', :web, :app, :db, primary: true
