# Copyright 2006-2008 by Mike Bailey. All rights reserved.
Capistrano::Configuration.instance(:must_exist).load do 
  namespace :deprec do
    namespace :redis do
      
  # set :memcache_ip, '127.0.0.1'
  # set :memcache_port, 11211
  # set :memcache_memory, 256
  
  # XXX needs thought/work
  
  desc "Install redis-rb gem"
  task :install_rubygem do
    # the gem currently needs to have rspec installed to make it work so that's why I install rspec here
    sudo "gem install rspec --no-ri --no-rdoc"
    ["cd /tmp && git clone git://github.com/ezmobius/redis-rb.git",
     "cd /tmp/redis-rb && sudo rake install"].each {|cmd| run cmd}
  end  
  
  desc "Start the Redis server"
  task :start do
    run "redis-server /etc/redis.conf"
  end
  
  desc "Stop the Redis server"
  task :stop do
    run 'echo "SHUTDOWN" | nc localhost 6379'
  end

  desc "Install redis"
  task :install do
    version = 'redis-1.02'
    set :src_package, {
      :file => version + '.tar.gz',   
      #:md5sum => 'a08851f7fa7b15e92ee6320b7a79c321  memcached-1.2.2.tar.gz', 
      :dir => version,  
      :url => "http://redis.googlecode.com/files/#{version}.tar.gz",
      :unpack => "tar zxf #{version}.tar.gz;",
      :make => 'make;',
      :post_install =>   "cp redis-benchmark /usr/bin/;
                          cp redis-cli /usr/bin/;
                          cp redis-server /usr/bin/;
                          cp redis.conf /etc/;
                          sed 's/daemonize no/daemonize yes/' /etc/redis.conf';"
    }
    deprec.download_src(src_package, src_dir)
    deprec.install_from_src(src_package, src_dir)
  end
end end
  
end