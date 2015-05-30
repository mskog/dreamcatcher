set :stage, :production
set :branch, :master

server "#{ENV['DEPLOY_HOST']}", user: "deployer", roles: %w{web app db workers}
