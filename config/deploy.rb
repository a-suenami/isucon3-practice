# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'isucon4'
set :repo_url, 'git@github.com:a-suenami/isucon3-practice.git'
set :deploy_to, '/home/isucon/production'

set :unicorn_conf, "#{fetch(:deploy_to)}/current/unicorn_config.rb"
set :unicorn_pid, "#{fetch(:deploy_to)}/shared/pids/unicorn.pid"

after 'deploy:publishing', 'deploy:restart'

namespace :deploy do
 
  task :restart do
    on roles :all do
      execute "if [ -f #{fetch(:unicorn_pid)} ]; then kill -USR2 `cat #{fetch(:unicorn_pid)}`; else cd #{fetch(:current_path)} && bundle exec unicorn -c #{fetch(:unicorn_conf)} -E #{fetch(:rack_env)} -D; fi"
    end
  end
 
  task :start do
    on roles :all do
      execute "cd #{fetch(:deploy_to)}/current && bundle exec unicorn -c #{fetch(:unicorn_conf)} -E #{fetch(:rack_env)} -D"
    end
  end
 
  task :stop do
    on roles :all do
      execute "if [ -f #{fetch(:unicorn_pid)} ]; then kill -QUIT `cat #{fetch(:unicorn_pid)}`; fi"
    end
  end
 
end

# namespace :deploy do
# 
#   desc 'Restart application'
#   task :restart do
#     on roles(:app), in: :sequence, wait: 5 do
#       run "if [ -f #{unicorn_pid} ]; then kill -USR2 `cat #{unicorn_pid}`; else cd #{deploy_to}/current && bundle exec unicorn -c #{unicorn_conf} -E #{rails_env} -D; fi"
#     end
#   end
# 
#   after :publishing, :restart
# 
#   after :restart, :clear_cache do
#     on roles(:web), in: :groups, limit: 3, wait: 10 do
#       within release_path do
#         execute :rake, 'cache:clear'
#       end
#     end
#   end
# 
# end
