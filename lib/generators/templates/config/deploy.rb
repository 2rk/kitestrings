require 'bundler/capistrano'
require 'rvm/capistrano'
require 'capistrano/ext/multistage'
require 'airbrake/capistrano'

set :stages, %w(integ, uat, production)
set :default_stage, "integ"
set :application, 'APP_NAME'
set :user, 'APP_NAME'
set (:deploy_to) { "/home/#{user}/apps/#{rails_env}" }
set :deploy_via, :remote_cache
set :use_sudo, false
set :scm, 'git'

#set :repository, 'git@github.com:2rk/APP_NAME.git'

set :ssl, false
# set :ssl_certificates_path, '/home/APP_NAME/ssl'
# set :ssl_certificates_name, 'APP_NAME'

set :rvm_ruby_string, File.read(".ruby-version").chomp
set :mysql_password, YAML::load_file("config/database.yml.server")["production"]["password"]
set :bundle_flags, "--deployment"

namespace :deploy do

  task :airbrake_test do
    run "cd #{current_path}; RAILS_ENV=#{stage} bin/rake airbrake:test; true"
  end

  task :nginx_conf do
    set :nginx_conf_file, "/opt/nginx/conf/servers/#{application}_#{stage}.conf"

    ssl_conf = <<ssl_conf
  ssl on;
  ssl_certificate #{ssl_certificates_path}/#{ssl_certificates_name}.crt;
  ssl_certificate_key #{ssl_certificates_path}/#{ssl_certificates_name}.key;

  passenger_set_cgi_param HTTPS on;
  passenger_set_cgi_param SSL_CLIENT_S_DN $ssl_client_s_dn;
  passenger_set_cgi_param SSL_CLIENT_VERIFY $ssl_client_verify;

  passenger_set_cgi_param HTTP_X_FORWARDED_PROTO https;
}

server {
  listen      80;
  server_name #{hostnames};
  rewrite     ^   https://#{hostnames}$request_uri? permanent;
ssl_conf

    conf = <<conf
server {
  listen #{ssl ? 443 : 80};
  server_name #{user}.#{stage}.tworedkites.com #{hostnames};
  root /home/#{user}/apps/#{stage}/current/public;
  passenger_enabled on;
  passenger_ruby /usr/local/rvm/bin/#{application}_ruby;
  rack_env production;
  client_max_body_size 10m;

#{ssl_conf}
}
conf

    put(conf, nginx_conf_file)

    run "sudo service nginx reload"
  end


  task :github_ssh_key do
    run "if [ ! -f ~/.ssh/id_rsa ]; then ssh-keygen -t rsa -f ~/.ssh/id_rsa -P ''; fi"
    # This will return an error back but it is not an issue
    run "ssh -T -oStrictHostKeyChecking=no git@github.com; true"
    run "cat .ssh/id_rsa.pub"
  end
  task :symlink_config do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  before "deploy:assets:precompile", "deploy:symlink_config"

  task :create_shared_database_config do
    run "mkdir -p #{shared_path}/config"
    top.upload File.expand_path('../database.yml.server', __FILE__), "#{shared_path}/config/database.yml"
  end


  task :create_shared_rvmrc do
    run "cp #{release_path}/.rvmrc.#{rails_env}.example #{release_path}/.rvmrc"
  end

  after "deploy:finalize_update", "deploy:create_shared_rvmrc"

  task :create_database do
    set :mysql_pass_arg, mysql_password.blank? ? '' : "-p#{mysql_password}"
    run "mysql --user=root #{mysql_pass_arg} -e \"CREATE DATABASE IF NOT EXISTS #{application}_#{stage}\""
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

namespace :ruby_make do
  desc "Run a task on a remote server."
  # run like: cap staging rake:invoke task=a_certain_task
  task :invoke do
    run("cd #{deploy_to}/current; bin/rake #{ENV['task']} RAILS_ENV=#{rails_env}")
  end
end

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  desc "reload the database with seed data"
  task :seed do
    run "cd #{current_path}; bin/rake db:seed RAILS_ENV=#{rails_env}"
  end
end

after 'deploy:setup', 'deploy:create_database', 'deploy:github_ssh_key', 'deploy:nginx_conf', 'deploy:create_shared_database_config'
after 'deploy:cold', 'deploy:airbrake_test'

before 'deploy:setup', 'rvm:install_rvm' # update RVM
before 'deploy:setup', 'rvm:install_ruby'
# only keep 5 most recent releases
after 'deploy:restart', 'deploy:cleanup'

# load additional deploy steps and configuration from lib/capistrano/*.cap files:
Dir["lib/capistrano/*.cap"].each { |file| load file }
