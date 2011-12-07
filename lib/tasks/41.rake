# encoding: utf-8

namespace :"41" do
  desc 'Update 4.1 stuff'
  task :update => :environment do
    require 'open-uri'
    puts "#{Time.now.to_s}: Update 4.1 stuff"
    puts "#{Time.now.to_s}: update *.src.rpm from 4.1 to database"
    branch = Branch.where(name: '4.1', vendor: 'ALT Linux').first
    Srpm.import_all(branch, '/ALT/4.1/files/SRPMS/*.src.rpm')
    Srpm.remove_old(branch, '/ALT/4.1/files/SRPMS/')
    puts "#{Time.now.to_s}: end"
    puts "#{Time.now.to_s}: update *.i586.rpm/*.noarch.rpm/*.x86_64.rpm from 4.1 to database"
    pathes = ['/ALT/4.1/files/i586/RPMS/*.i586.rpm',
              '/ALT/4.1/files/noarch/RPMS/*.noarch.rpm',
              '/ALT/4.1/files/x86_64/RPMS/*.x86_64.rpm']
    Package.import_all(branch, pathes)
    puts "#{Time.now.to_s}: end"
  end

#   desc "Import all ACL for packages from 4.1 to database"
#   task :acls => :environment do
#     require 'open-uri'
#     puts "#{Time.now.to_s}: import acls"
#     Acl.import_acls('ALT Linux', '4.1', 'http://git.altlinux.org/acl/list.packages.4.1')
#     puts "#{Time.now.to_s}: end"
#   end

  desc 'Import *.src.rpm from 4.1 to database'
  task :srpms => :environment do
    require 'open-uri'
    puts "#{Time.now.to_s}: import *.src.rpm from 4.1 to database"
    branch = Branch.where(name: '4.1', vendor: 'ALT Linux').first
    Srpm.import_all(branch, '/ALT/4.1/files/SRPMS/*.src.rpm')
    puts "#{Time.now.to_s}: end"
  end

  desc 'Import *.i586.rpm/*.noarch.rpm/*.x86_64.rpm from 4.1 to database'
  task :binary => :environment do
    require 'open-uri'
    puts "#{Time.now.to_s}: import *.i586.rpm/*.noarch.rpm/*.x86_64.rpm from 4.1 to database"
    branch = Branch.where(name: '4.1', vendor: 'ALT Linux').first
    pathes = ['/ALT/4.1/files/i586/RPMS/*.i586.rpm',
              '/ALT/4.1/files/noarch/RPMS/*.noarch.rpm',
              '/ALT/4.1/files/x86_64/RPMS/*.x86_64.rpm']
    Package.import_all(branch, pathes)
    puts "#{Time.now.to_s}: end"
  end

#   desc "Import all ACL for packages from 4.1 to database (leaders)"
#   task :leaders => :environment do
#     require 'open-uri'
#     puts "#{Time.now.to_s}: import leaders"
#     Leader.import_leaders('ALT Linux', '4.1', 'http://git.altlinux.org/acl/list.packages.4.1')
#     puts "#{Time.now.to_s}: end"
#   end
# 
#   desc "Import all teams from 4.1 to database"
#   task :teams => :environment do
#     require 'open-uri'
#     puts "#{Time.now.to_s}: import teams"
#     Team.import_teams('ALT Linux', '4.1', 'http://git.altlinux.org/acl/list.groups.4.1')
#     puts "#{Time.now.to_s}: end"
#   end
end
