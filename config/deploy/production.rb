set :stage, :production

server "levumi.informatik.uni-kiel.de", roles: %w{web app db}, user: 'levumi', password: 'levumi', primary: true

set :web_user, 'www-data'

set :rails_env, :production

set :default_env, {'PASSENGER_INSTANCE_REGISTRY_DIR': '/var/run/passenger'}
