Capistrano::Configuration.instance(:must_exist).load do 
  
  namespace :deprec do
    namespace :thin do
        
      set :thin, 8
      set(:thin_environment) { rails_env }
      set(:thin_log_dir) { "#{deploy_to}/shared/log" }
      set(:thin_pid_dir) { "#{deploy_to}/shared/pids" }
      
      desc "Install thin"
      task :install, :roles => :app do
        gem2.install 'thin'
      end
    end
  end
end