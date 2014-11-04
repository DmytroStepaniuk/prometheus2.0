namespace :redis do
  desc 'Cache all *.src.rpm and all binary *.rpm in redis'
  task cache: :environment do
    require 'open-uri'

    Rails.logger.info "#{ Time.now }: cache all *.src.rpm info in redis"

    if Redis.current.get('__SYNC__')
      exist = begin
                Process::kill(0, Redis.current.get('__SYNC__').to_i)
                true
              rescue
                false
              end
      if exist
        Rails.logger.info "#{ Time.now }: update is locked by another cron script"
        Process.exit!(true)
      else
        Rails.logger.info "#{ Time.now }: dead lock found and deleted"
        Redis.current.del('__SYNC__')
      end
    end
    Redis.current.set('__SYNC__', Process.pid)

    branches = Branch.where(vendor: 'ALT Linux')

    branches.each do |branch|
      branch.recount!
    end

    branches.each do |branch|
      srpms = Srpm.where(branch_id: branch).select('filename')
      srpms.each { |srpm| Redis.current.set("#{ branch.name }:#{ srpm.filename }", 1) }
    end
    Rails.logger.info "#{ Time.now }: end"

    Rails.logger.info "#{ Time.now }: cache all binary files info in redis"
    branches.each do |branch|
      packages = Package.where(branch_id: branch).select('filename')
      packages.each { |package| Redis.current.set("#{ branch.name }:#{ package.filename }", 1) }
    end
    Rails.logger.info "#{ Time.now }: end"

    Rails.logger.info "#{ Time.now }: cache all acls in redis"
    Acl.update_redis_cache('ALT Linux', 'Sisyphus', 'http://git.altlinux.org/acl/list.packages.sisyphus')
    Acl.update_redis_cache('ALT Linux', 'p7', 'http://git.altlinux.org/acl/list.packages.p7')
    Acl.update_redis_cache('ALT Linux', 't7', 'http://git.altlinux.org/acl/list.packages.t7')
    Acl.update_redis_cache('ALT Linux', 'Platform6', 'http://git.altlinux.org/acl/list.packages.p6')
    Acl.update_redis_cache('ALT Linux', 't6', 'http://git.altlinux.org/acl/list.packages.t6')
    Acl.update_redis_cache('ALT Linux', 'Platform5', 'http://git.altlinux.org/acl/list.packages.p5')
    Acl.update_redis_cache('ALT Linux', '5.1', 'http://git.altlinux.org/acl/list.packages.5.1')
    Acl.update_redis_cache('ALT Linux', '5.0', 'http://git.altlinux.org/acl/list.packages.5.0')
    Acl.update_redis_cache('ALT Linux', '4.1', 'http://git.altlinux.org/acl/list.packages.4.1')
    Acl.update_redis_cache('ALT Linux', '4.0', 'http://git.altlinux.org/acl/list.packages.4.0')
    Rails.logger.info "#{ Time.now }: end"

    Rails.logger.info "#{ Time.now }: cache all leaders in redis"
    Leader.update_redis_cache('ALT Linux', 'Sisyphus', 'http://git.altlinux.org/acl/list.packages.sisyphus')
    Leader.update_redis_cache('ALT Linux', 'p7', 'http://git.altlinux.org/acl/list.packages.p7')
    Leader.update_redis_cache('ALT Linux', 't7', 'http://git.altlinux.org/acl/list.packages.t7')
    Leader.update_redis_cache('ALT Linux', 'Platform6', 'http://git.altlinux.org/acl/list.packages.p6')
    Leader.update_redis_cache('ALT Linux', 't6', 'http://git.altlinux.org/acl/list.packages.t6')
    Leader.update_redis_cache('ALT Linux', 'Platform5', 'http://git.altlinux.org/acl/list.packages.p5')
    Leader.update_redis_cache('ALT Linux', '5.1', 'http://git.altlinux.org/acl/list.packages.5.1')
    Leader.update_redis_cache('ALT Linux', '5.0', 'http://git.altlinux.org/acl/list.packages.5.0')
    Leader.update_redis_cache('ALT Linux', '4.1', 'http://git.altlinux.org/acl/list.packages.4.1')
    Leader.update_redis_cache('ALT Linux', '4.0', 'http://git.altlinux.org/acl/list.packages.4.0')
    Rails.logger.info "#{ Time.now }: end"

    Redis.current.del('__SYNC__')
  end
end
