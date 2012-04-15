# encoding: utf-8

namespace :t6 do
  desc 'Update t6 stuff'
  task :update => :environment do
    require 'open-uri'
    puts "#{Time.now.to_s}: Update t6 stuff"
    if $redis.get('__SYNC__')
      puts "#{Time.now.to_s}: update is locked by another cron script"
      Process.exit!(true)
    end
    $redis.set('__SYNC__', 1)
    puts "#{Time.now.to_s}: update *.src.rpm from t6 to database"
    branch = Branch.where(name: 't6', vendor: 'ALT Linux').first
    Srpm.import_all(branch, '/ALT/t6/files/SRPMS/*.src.rpm')
    Srpm.remove_old(branch, '/ALT/t6/files/SRPMS/')
    puts "#{Time.now.to_s}: end"
    puts "#{Time.now.to_s}: update *.i586.rpm/*.noarch.rpm/*.x86_64.rpm from t6 to database"
    pathes = ['/ALT/t6/files/i586/RPMS/*.i586.rpm',
              '/ALT/t6/files/noarch/RPMS/*.noarch.rpm',
              '/ALT/t6/files/x86_64/RPMS/*.x86_64.rpm']
    Package.import_all(branch, pathes)
    puts "#{Time.now.to_s}: end"
    # TODO: review and cleanup this code
    puts "#{Time.now.to_s}: expire cache"
    ['en', 'ru', 'uk', 'br'].each do |locale|
      ActionController::Base.new.expire_fragment("#{locale}_srpms_#{branch.name}_")
      pages_counter = (branch.srpms.where("srpms.created_at > '2010-11-09 09:00:00'").count / 50) + 1
      for page in 1..pages_counter do
        ActionController::Base.new.expire_fragment("#{locale}_srpms_#{branch.name}_#{page}")
      end
    end
    puts "#{Time.now.to_s}: end"
    puts "#{Time.now.to_s}: update acls in redis cache"
    Acl.update_redis_cache('ALT Linux', 't6', 'http://git.altlinux.org/acl/list.packages.t6')
    puts "#{Time.now.to_s}: end"
    puts "#{Time.now.to_s}: update time"
    $redis.set("#{branch.name}:updated_at", Time.now.to_s)
    puts "#{Time.now.to_s}: end"
    $redis.del('__SYNC__')
  end

  desc 'Import all ACL for packages from t6 to database'
  task :acls => :environment do
    require 'open-uri'
    puts "#{Time.now.to_s}: import all acls for packages from t6 to database"
    Acl.create_redis_cache('ALT Linux', 't6', 'http://git.altlinux.org/acl/list.packages.t6')
    puts "#{Time.now.to_s}: end"
  end

  desc 'Import *.src.rpm from t6 to database'
  task :srpms => :environment do
    require 'open-uri'
    puts "#{Time.now.to_s}: import *.src.rpm from t6 to database"
    branch = Branch.where(name: 't6', vendor: 'ALT Linux').first
    Srpm.import_all(branch, '/ALT/t6/files/SRPMS/*.src.rpm')
    puts "#{Time.now.to_s}: end"
  end

  desc 'Import *.i586.rpm/*.noarch.rpm/*.x86_64.rpm from t6 to database'
  task :binary => :environment do
    require 'open-uri'
    puts "#{Time.now.to_s}: import *.i586.rpm/*.noarch.rpm/*.x86_64.rpm from t6 to database"
    branch = Branch.where(name: 't6', vendor: 'ALT Linux').first
    pathes = ['/ALT/t6/files/i586/RPMS/*.i586.rpm',
              '/ALT/t6/files/noarch/RPMS/*.noarch.rpm',
              '/ALT/t6/files/x86_64/RPMS/*.x86_64.rpm']
    Package.import_all(branch, pathes)
    puts "#{Time.now.to_s}: end"
  end
end
