# -*- encoding : utf-8 -*-
set :stage, :production

server "levumi.informatik.uni-kiel.de", roles: %w{web app db}, user: 'levumi', password: 'levumi', primary: true

set :web_user, 'www-data'

set :asset_env, "RAILS_RELATIVE_URL_ROOT=/preview"

set :rails_env, :production

namespace :deploy do
  after :deploy, :'passenger:restart'
end