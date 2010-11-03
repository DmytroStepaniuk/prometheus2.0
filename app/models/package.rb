class Package < ActiveRecord::Base
  validates :srpm_id, :presence => true
  validates :branch_id, :presence => true
  validates :group_id, :presence => true

  belongs_to :srpm
  belongs_to :branch
  belongs_to :group

  def self.import_rpm(vendor, branch, file)
    br = Branch.first :conditions => { :name => branch, :vendor => vendor }
    rpm = RPM::Package::open(file)
    package = Package.new
    package.filename = file.split('/')[-1]
    package.sourcepackage = rpm[1044]
    package.name = rpm.name
    package.version = rpm.version.v
    package.release = rpm.version.r
    package.arch = rpm.arch

    case rpm[1016].split('/').count
    when 1
      group = br.groups.where(:name => rpm[1016], :parent_id => nil).first
    when 2
      group = br.groups.where(:name => rpm[1016].split('/')[0], :parent_id => nil).first.children.where(:name => rpm[1016].split('/')[1]).first
    when 3
      group = br.groups.where(:name => rpm[1016].split('/')[0], :parent_id => nil).first.children.where(:name => rpm[1016].split('/')[1]).first.children.where(:name => rpm[1016].split('/')[2]).first
    else
      puts Time.now.to_s + ": too nested groups level"
    end    

    package.group_id = group.id
    package.epoch = rpm[1003]
    package.summary = rpm[1004]
    package.summary = 'Broken' if rpm.name == 'openmoko_dfu-util'
    package.license = rpm[1014]
    package.url = rpm[1020]
    package.description = rpm[1005]
    package.buildtime = Time.at(rpm[1006])
    package.size = File.size(file)
    package.branch_id = br.id
    srpm = Srpm.find :first, :conditions => { :filename => rpm[1044], :branch_id => br.id }
    package.srpm_id = srpm.id
    if package.save
      $redis.set br.name + ":" + package.filename, 1
      puts Time.now.to_s + ": updated '" + package.filename + "'"
    else
      puts Time.now.to_s + ": failed to update '" + package.filename + "'"
    end
  end

  def self.import_packages_i586(vendor, branch, path)
    br = Branch.first :conditions => { :name => branch, :vendor => vendor }
    Dir.glob(path).each do |file|
      begin
        rpm = RPM::Package::open(file)
        package = Package.new
        package.filename = rpm.name + '-' + rpm.version.v + '-' + rpm.version.r + '.i586.rpm'
        package.sourcepackage = rpm[1044]
        package.name = rpm.name
        package.version = rpm.version.v
        package.release = rpm.version.r
        package.arch = rpm.arch

        case rpm[1016].split('/').count
        when 1
          group = br.groups.where(:name => rpm[1016], :parent_id => nil).first
        when 2
          group = br.groups.where(:name => rpm[1016].split('/')[0], :parent_id => nil).first.children.where(:name => rpm[1016].split('/')[1]).first
        when 3
          group = br.groups.where(:name => rpm[1016].split('/')[0], :parent_id => nil).first.children.where(:name => rpm[1016].split('/')[1]).first.children.where(:name => rpm[1016].split('/')[2]).first
        else
          puts Time.now.to_s + ": too nested groups level"
        end    

        package.group_id = group.id
        package.epoch = rpm[1003]
        package.summary = rpm[1004]
        package.summary = 'Broken' if rpm.name == 'openmoko_dfu-util'
        package.license = rpm[1014]
        package.url = rpm[1020]
        package.description = rpm[1005]
        package.buildtime = Time.at(rpm[1006])
        package.size = File.size(file)
        package.branch_id = br.id
        srpm = Srpm.find :first, :conditions => { :filename => rpm[1044], :branch_id => br.id }
        package.srpm_id = srpm.id
        package.save!
      rescue RuntimeError
        puts "Bad .rpm: " + file
      end
    end
  end

  def self.import_packages_noarch(vendor, branch, path)
    br = Branch.first :conditions => { :name => branch, :vendor => vendor }
    Dir.glob(path).each do |file|
      begin
        rpm = RPM::Package::open(file)
        package = Package.new
        package.filename = rpm.name + '-' + rpm.version.v + '-' + rpm.version.r + '.noarch.rpm'
        package.sourcepackage = rpm[1044]
        package.name = rpm.name
        package.version = rpm.version.v
        package.release = rpm.version.r
        package.arch = rpm.arch

        case rpm[1016].split('/').count
        when 1
          group = br.groups.where(:name => rpm[1016], :parent_id => nil).first
        when 2
          group = br.groups.where(:name => rpm[1016].split('/')[0], :parent_id => nil).first.children.where(:name => rpm[1016].split('/')[1]).first
        when 3
          group = br.groups.where(:name => rpm[1016].split('/')[0], :parent_id => nil).first.children.where(:name => rpm[1016].split('/')[1]).first.children.where(:name => rpm[1016].split('/')[2]).first
        else
          puts Time.now.to_s + ": too nested groups level"
        end    

        package.group_id = group.id
        package.epoch = rpm[1003]
        package.summary = rpm[1004]
        package.summary = 'Broken' if rpm.name == 'openmoko_dfu-util'
        package.license = rpm[1014]
        package.url = rpm[1020]
        package.description = rpm[1005]
        package.buildtime = Time.at(rpm[1006])
        package.size = File.size(file)
        package.branch_id = br.id
        srpm = Srpm.find :first, :conditions => { :filename => rpm[1044], :branch_id => br.id }
        package.srpm_id = srpm.id
        package.save!
      rescue RuntimeError
        puts "Bad .rpm: " + file
      end
    end
  end

  def self.import_packages_x86_64(vendor, branch, path)
    br = Branch.first :conditions => { :name => branch, :vendor => vendor }
    Dir.glob(path).each do |file|
      begin
        rpm = RPM::Package::open(file)
        package = Package.new
        package.filename = rpm.name + '-' + rpm.version.v + '-' + rpm.version.r + '.x86_64.rpm'
        package.sourcepackage = rpm[1044]
        package.name = rpm.name
        package.version = rpm.version.v
        package.release = rpm.version.r
        package.arch = rpm.arch

        case rpm[1016].split('/').count
        when 1
          group = br.groups.where(:name => rpm[1016], :parent_id => nil).first
        when 2
          group = br.groups.where(:name => rpm[1016].split('/')[0], :parent_id => nil).first.children.where(:name => rpm[1016].split('/')[1]).first
        when 3
          group = br.groups.where(:name => rpm[1016].split('/')[0], :parent_id => nil).first.children.where(:name => rpm[1016].split('/')[1]).first.children.where(:name => rpm[1016].split('/')[2]).first
        else
          puts Time.now.to_s + ": too nested groups level"
        end    

        package.group_id = group.id
        package.epoch = rpm[1003]
        package.summary = rpm[1004]
        package.summary = 'Broken' if rpm.name == 'openmoko_dfu-util'
        package.license = rpm[1014]
        package.url = rpm[1020]
        package.description = rpm[1005]
        package.buildtime = Time.at(rpm[1006])
        package.size = File.size(file)
        package.branch_id = br.id
        srpm = Srpm.find :first, :conditions => { :filename => rpm[1044], :branch_id => br.id }
        package.srpm_id = srpm.id
        package.save!
      rescue RuntimeError
        puts "Bad .rpm: " + file
      end
    end
  end
  
  def self.import_packages_arm(vendor, branch, path)
    br = Branch.first :conditions => { :name => branch, :vendor => vendor }
    Dir.glob(path).each do |file|
      begin
        rpm = RPM::Package::open(file)
        package = Package.new
        package.filename = rpm.name + '-' + rpm.version.v + '-' + rpm.version.r + '.' + rpm.arch + '.rpm'
        package.sourcepackage = rpm[1044]
        package.name = rpm.name
        package.version = rpm.version.v
        package.release = rpm.version.r
        package.arch = rpm.arch
        
        case rpm[1016].split('/').count
        when 1
          group = br.groups.where(:name => rpm[1016], :parent_id => nil).first
        when 2
          group = br.groups.where(:name => rpm[1016].split('/')[0], :parent_id => nil).first.children.where(:name => rpm[1016].split('/')[1]).first
        when 3
          group = br.groups.where(:name => rpm[1016].split('/')[0], :parent_id => nil).first.children.where(:name => rpm[1016].split('/')[1]).first.children.where(:name => rpm[1016].split('/')[2]).first
        else
          puts Time.now.to_s + ": too nested groups level"
        end    

        package.group_id = group.id
        package.epoch = rpm[1003]
        package.summary = rpm[1004]
        package.summary = 'Broken' if rpm.name == 'openmoko_dfu-util'
        package.license = rpm[1014]
        package.url = rpm[1020]
        package.description = rpm[1005]
        package.buildtime = Time.at(rpm[1006])
        package.size = File.size(file)
        package.branch_id = br.id
        srpm = Srpm.find :first, :conditions => { :filename => rpm[1044], :branch_id => br.id }
        package.srpm_id = srpm.id
        package.save!
      rescue RuntimeError
        puts "Bad .rpm: " + file
      end
    end
  end
end