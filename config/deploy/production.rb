# Settings for staging server
server '52.8.6.164',:app, :web, :db, :primary => true
set :rails_env, 'production'

set :use_sudo, false
set :deploy_via, :remote_cache
set :user, 'w3villa'
set :rvm_ruby_version, 'ruby-2.1.0'
set :deploy_to, "/home/#{user}/#{application}"
set :branch, 'master'
