server '52.198.20.34', user: 'app', roles: %w{app db web}
set :ssh_options, keys: '/Users/tsuna/.ssh/id_rsa'
