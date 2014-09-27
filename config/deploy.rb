# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'isucon4'
set :repo_url, 'git@github.com:a-suenami/isucon3-practice.git'
set :deploy_to, '/home/isucon/webapp/ruby'

set :unicorn_conf, "#{deploy_to}/current/unicorn_config.rb"
set :unicorn_pid, "#{deploy_to}/shared/pids/unicorn.pid"

namespace :deploy do
 
  task :restart do
    run "if [ -f #{unicorn_pid} ]; then kill -USR2 `cat #{unicorn_pid}`; else cd #{current_path} && bundle exec unicorn -c #{unicorn_conf} -E #{rack_env} -D; fi"
  end
 
  task :start do
    run "cd #{current_path} && bundle exec unicorn -c #{unicorn_conf} -E #{rack_env} -D"
  end
 
  task :stop do
    run "if [ -f #{unicorn_pid} ]; then kill -QUIT `cat #{unicorn_pid}`; fi"
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
