default_run_options[:pty] = true
ssh_options[:forward_agent] = true
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
set :use_sudo, true 

set :deploy_via, :copy

set :rvm_type, :user
#set :rvm_install_with_sudo, true
set :rvm_ruby_string, 'ruby-1.9.3-p362'
require "rvm/capistrano" 
before 'deploy:setup', 'rvm:install_rvm'
#before 'rvm:install_ruby', 'deploy:add_user_to_rvm_group'
#
before 'deploy:setup', 'rvm:install_ruby'
ENV['GEM']='bundler'
before 'deploy:setup', 'deploy:rvm_requirements'

before 'deploy:setup', 'rvm:install_gem'

require "bundler/capistrano"
#set :bundle_flags, "--system --quiet"
#set :bundle_dir, ''

after 'deploy:update_code', 'bundle:install'
#after 'deploy:update_code', 'deploy:unicorn_wrapper'
after 'deploy:update_code', 'deploy:file_permissions'
before 'deploy:restart', 'deploy:migrate'
before 'deploy:restart', 'deploy:init_script'
before 'deploy:restart', 'deploy:restart_app'
before 'deploy:restart', 'deploy:nginx_site'
namespace :deploy do
#  task :add_user_to_rvm_group do
#    run "#{sudo} usermod -a -G rvm #{user}"
#  end
  task :rvm_requirements do
    run "#{sudo} apt-get -y install build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion pkg-config libmysql-ruby libmysqlclient-dev"
  end
#  task :unicorn_wrapper do
#    run "rvm wrapper #{rvm_ruby_string} #{application} unicorn_rails"
#  end
  task :file_permissions do
    run "#{sudo} chown -R #{user}:www-data #{deploy_to}"
  end
  task :restart_app, :roles => :app, :except => { :no_release => true } do
    run "#{sudo} service #{application} restart"
  end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{sudo} service nginx restart"
  end
  task :init_script, :roles => :app, :except => { :no_release => true } do
    run "#{sudo} cp #{deploy_to}/current/config/init.d /etc/init.d/#{application}" 
    run "#{sudo} chmod +x /etc/init.d/#{application}"
    run "#{sudo} update-rc.d #{application} defaults"
  end
  task :nginx_site, :roles => :app, :except => { :no_release => true } do
    run "#{sudo} cp -f #{deploy_to}/current/config/#{application}.conf /etc/nginx/sites-available"
    run "#{sudo} ln -f -s /etc/nginx/sites-available/#{application}.conf /etc/nginx/sites-enabled/#{application}.conf"
  end 
end
