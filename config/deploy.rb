# -*- encoding : utf-8 -*-
# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'levumi'
set :deploy_user, 'administrator'

set :scm, :git
set :repo_url,  'levumi@levumi.informatik.uni-kiel.de:/var/git/levumi.git'

set :deploy_to, "/var/www/levumi"
set :deploy_via, :remote_cache

set :tests, []

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
set :pty, true

SSHKit.config.command_map[:rake]  = "bundle exec rake"
SSHKit.config.command_map[:rails] = "bundle exec rails"

set :linked_dirs, fetch(:linked_dirs, []).push('log')
#set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5
