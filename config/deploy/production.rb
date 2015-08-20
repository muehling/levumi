# -*- encoding : utf-8 -*-
set :stage, :production
set :branch, 'master'

server "vmhub1.informatik.tu-muenchen.de", user: 'administrator', password: 'DDI?istcool!', roles: %w{web app db}, :primary => true
set :web_user, 'www-data'

set :use_sudo, false

set :asset_env, "RAILS_RELATIVE_URL_ROOT=/levumi"

set :rails_env, :production

namespace :custom do

   task :chown do
     on roles(:app) do
       execute :sudo, "chown -R #{fetch(:user)}:#{fetch(:web_user)} #{fetch(:deploy_to)}"
     end
   end

#   task :symlink do
#     on roles(:app) do
#       execute :sudo, "ln -s #{fetch(:deploy_to)}/current/public /var/www/levumi"
#       execute :sudo, "chown -R #{fetch(:user)}:#{fetch(:web_user)} /var/www/levumi"
#     end
#   end

 end
#
# after "deploy:setup", "custom:chown"
# after "deploy:update", "custom:chown"
# after "deploy:symlink", "custom:symlink"

namespace :deploy do
  after :deploy, "custom:chown"
end