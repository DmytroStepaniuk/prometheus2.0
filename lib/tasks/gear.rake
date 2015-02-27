namespace :gear do
  desc 'Import all git repos to database'
  task :import => :environment do
    require 'open-uri'

    puts "#{Time.now.to_s}: import gitrepos"
    if Redis.current.get('__SYNC__')
      exist = begin
                Process::kill(0, Redis.current.get('__SYNC__').to_i)
                true
              rescue
                false
              end
      if exist
        puts "#{Time.now.to_s}: update is locked by another cron script"
        Process.exit!(true)
      else
        puts "#{Time.now.to_s}: dead lock found and deleted"
        Redis.current.del('__SYNC__')
      end
    end
    Redis.current.set('__SYNC__', Process.pid)
    Gear.import_gitrepos('http://git.altlinux.org/people-packages-list')
    puts "#{Time.now.to_s}: end"
    Redis.current.del('__SYNC__')
  end

  desc 'Update all git repos to database'
  task :update => :environment do
    require 'open-uri'

    puts "#{Time.now.to_s}: update gitrepos"
    if Redis.current.get('__SYNC__')
      exist = begin
                Process::kill(0, Redis.current.get('__SYNC__'))
                true
              rescue
                false
              end
      if exist
        puts "#{Time.now.to_s}: update is locked by another cron script"
        Process.exit!(true)
      else
        puts "#{Time.now.to_s}: dead lock found and deleted"
        Redis.current.del('__SYNC__')
      end
    end
    Redis.current.set('__SYNC__', Process.pid)
    Gear.update_gitrepos('http://git.altlinux.org/people-packages-list')
    puts "#{Time.now.to_s}: end"
    Redis.current.del('__SYNC__')
  end
end
