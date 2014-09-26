namespace :sisyphusarm do
  desc 'Update SisyphusARM stuff'
  task :update => :environment do
    require 'open-uri'
    puts "#{ Time.now }: Update SisyphusARM stuff"
    if $redis.get('__SYNC__')
      exist = begin
                Process::kill(0, $redis.get('__SYNC__').to_i)
                true
              rescue
                false
              end
      if exist
        puts "#{ Time.now }: update is locked by another cron script"
        Process.exit!(true)
      else
        puts "#{ Time.now }: dead lock found and deleted"
        $redis.del('__SYNC__')
      end
    end
    $redis.set('__SYNC__', Process.pid)
    puts "#{ Time.now }: update *.src.rpm from SisyphusARM to database"
    branch = Branch.where(name: 'SisyphusARM', vendor: 'ALT Linux').first
    ThinkingSphinx::Deltas.suspend! if ENV['PROMETHEUS2_BOOTSTRAP'] == 'yes'
    Srpm.import_all(branch, '/ALT/Sisyphus/arm/SRPMS.all/*.src.rpm')
    Srpm.remove_old(branch, '/ALT/Sisyphus/arm/SRPMS.all/')
    puts "#{ Time.now }: end"
    puts "#{ Time.now }: update *.arm.rpm/*.noarch.rpm from SisyphusARM to database"
    pathes = ['/ALT/Sisyphus/files/arm/RPMS/*.rpm']
    Package.import_all(branch, pathes)
    ThinkingSphinx::Deltas.resume! if ENV['PROMETHEUS2_BOOTSTRAP'] == 'yes'
    puts "#{ Time.now }: end"
#    # TODO: review and cleanup this code
#    puts "#{ Time.now }: expire cache"
#    ['en', 'ru', 'uk', 'br'].each do |locale|
#      ActionController::Base.new.expire_fragment("#{ locale }_srpms_#{ branch.name }_")
#      pages_counter = (branch.srpms.where("srpms.created_at > '2010-11-09 09:00:00'").count / 50) + 1
#      for page in 1..pages_counter do
#        ActionController::Base.new.expire_fragment("#{ locale }_srpms_#{ branch.name }_#{ page }")
#      end
#    end
#    puts "#{ Time.now }: end"
    puts "#{ Time.now }: update time"
    # TODO: write to updated_at int
    $redis.set("#{ branch.name }:updated_at", Time.now.to_s)
    puts "#{ Time.now }: end"
    $redis.del('__SYNC__')
  end

  desc 'Import *.src.rpm from SisyphusARM to database'
  task :srpms => :environment do
    require 'open-uri'
    puts "#{ Time.now }: import *.src.rpm from SisyphusARM to database"
    branch = Branch.where(name: 'SisyphusARM', vendor: 'ALT Linux').first
    Srpm.import_all(branch, '/ALT/Sisyphus/arm/SRPMS.all/*.src.rpm')
    puts "#{ Time.now }: end"
  end

  desc 'Import *.arm.rpm/*.noarch.rpm from SisyphusARM to database'
  task :binary => :environment do
    require 'open-uri'
    puts "#{ Time.now }: import *.arm.rpm/*.noarch.rpm from SisyphusARM to database"
    branch = Branch.where(name: 'SisyphusARM', vendor: 'ALT Linux').first
    pathes = ['/ALT/Sisyphus/files/arm/RPMS/*.rpm']
    Package.import_all(branch, pathes)
    puts "#{ Time.now }: end"
  end
end
