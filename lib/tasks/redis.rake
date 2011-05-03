namespace :redis do
  desc "Cache all *.src.rpm and all binary *.rpm in redis"
  task :cache => :environment do

    puts "#{Time.now.to_s}: cache all *.src.rpm info in redis"
    branches = Branch.all :conditions => { :vendor => 'ALT Linux' }
    branches.each do |branch|
      if !$redis.exists branch.name + ":CACHED"
        srpms = Srpm.all :conditions => { :branch_id => branch.id }
        srpms.each { |srpm| $redis.set branch.name + ":" + srpm.filename, 1 }
        $redis.set branch.name + ":CACHED", "yes"
      else
        puts "#{Time.now.to_s}: srpm info for #{branch.name} already in cache"
      end
    end
    puts "#{Time.now.to_s}: end"

    puts "#{Time.now.to_s}: cache all binary files info in redis"
    # branches = Branch.all :conditions => { :vendor => 'ALT Linux' }
    branches.each do |branch|
      if !$redis.exists branch.name + ":binary:CACHED"
        packages = Package.all :conditions => { :branch_id => branch.id }
        packages.each { |package| $redis.set branch.name + ":" + package.filename, 1 }
        $redis.set branch.name + ":binary:CACHED", "yes"
      else
        puts "#{Time.now.to_s}: binary files info for #{branch.name} already in cache"
      end
    end
    puts "#{Time.now.to_s}: end"

  end
end
