# -*- encoding : utf-8 -*-
# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'levumi'
set :deploy_user, 'administrator'

set :scm, :git
set :repo_url,  'git@vmhub1.informatik.tu-muenchen.de:/var/git/levumi.git'

set :deploy_to, "/var/webapps/levumi"

set :rvm_type, :user

set :tests, []

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
set :pty, true

set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

#set :passenger_restart_with_touch, true
