lock '3.5.0'

set :application, 'limo-logix'
set :repo_url, 'git@bitbucket.org:uitouxteam/limologix-backend.git'
ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
set :scm, :git

set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')


namespace :deploy do
  task :restart do
    on roles(:app), in: :groups, limit: 3, wait: 10 do
      within release_path do
        execute :bundle, "exec thin restart -e #{fetch(:stage)} --server 2 --socket #{release_path}/tmp/sockets/thin.sock"
      end
    end
  end
  after :publishing, :restart

  desc 'Runs rake db:seed for SeedMigrations data'
  task :seed => [:set_rails_env] do
    on roles(:db) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "db:seed"
        end
      end
    end
  end

  task :faye do
    on roles(:app), in: :groups, limit: 3, wait: 10 do
      within release_path do
        execute :bundle, "exec thin start -R faye.ru -e #{fetch(:stage)} -p9292 -d"
      end
    end
  end

  after :migrate, :seed
end

namespace :sidekiq do

  task :restart do
    invoke 'sidekiq:stop'
    invoke 'sidekiq:start'
  end

  before 'deploy:finished', 'sidekiq:restart'

  task :stop do
    on roles(:app) do
      within current_path do
        pid = p capture "ps aux | grep sidekiq | awk '{print $2}' | sed -n 1p"
        execute("kill -9 #{pid}")
      end
    end
  end

  task :start do
    on roles(:app) do
      within current_path do
        execute :bundle, "exec sidekiq -e #{fetch(:stage)} -C config/sidekiq.yml -d"
      end
    end
  end
end
