default_run_options[:pty] = true
set :application, "blog"
set :repository,  "https://github.com/voicedata/blog.git"

set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :deploy_to, "/opt/www/blog"

# role :web, "your web-server here"                          # Your HTTP server, Apache/etc
# role :app, "your app-server here"                          # This may be the same as your `Web` server
# role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
# role :db,  "your slave db-server here"

server "210.50.199.199", :web, :app, :db, :primary => true

set :user, "webmstr"
set :scm_username, 'voicedata'
set :use_sudo, false

set :deploy_via, :copy

set :rvm_ruby_string, 'ruby-1.9.3@blog'
require "rvm/capistrano" 
before 'deploy:setup', 'rvm:install_ruby'
ENV['GEM']='bundler'
before 'deploy:setup', 'rvm:install_gem'

require "bundler/capistrano"
set :bundle_flags, "--system --quiet"
set :bundle_dir, ''
after 'deploy:update_code', 'bundle:install'
after 'bundle:install', 'deploy:install_ruby_wrapper'
#before 'deploy:restart', 'deploy:change_permissions'
namespace :deploy do
  task :install_ruby_wrapper do
    run "rvm wrapper #{rvm_ruby_string} #{application} unicorn_rails"
  end

  task :change_permissions do
    run "chown -R #{user}:www-data #{deploy_to}"
  end
  task :restart_app, :roles => :app, :except => { :no_release => true } do

  end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{sudo} service nginx restart"
  end
  task :init_script, :roles => :app, :except => { :no_release => true } do
    run "#{sudo} cp #{deploy_to}/current/config/init.d /etc/init.d/#{application}" 
  end
end
# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
