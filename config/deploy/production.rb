# -*- encoding : utf-8 -*-
set :stage, :production

server "levumi.informatik.uni-kiel.de", roles: %w{web app db}, user: 'levumi', password: 'levumi', primary: true

set :web_user, 'www-data'

set :rails_env, :production

namespace :deploy do
  after :deploy, 'webpacker:compile'
end