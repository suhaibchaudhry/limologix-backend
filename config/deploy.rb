lock '3.5.0'

set :application, 'limo-logix'
set :repo_url, 'git@bitbucket.org:uitouxteam/limologix-backend.git'
ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
set :scm, :git

set :linked_files, fetch(:linked_files, []).push('config/database.yml')
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

  after :migrate, :seed
end


# Default branch is :master

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5
