pid_file = "#{deploy_to}/shared/pids/unicorn.pid"

pid pid_file

worker_processes 10
preload_app true
