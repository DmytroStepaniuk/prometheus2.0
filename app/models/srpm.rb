class Srpm < ActiveRecord::Base
  belongs_to :branch
  belongs_to :group

  validates :branch, presence: true
  validates :group, presence: true
  validates :groupname, presence: true
  validates :md5, presence: true

  has_many :packages, dependent: :destroy
  has_many :changelogs, dependent: :destroy
  has_one :specfile, dependent: :destroy
  has_many :patches, dependent: :destroy
  has_many :sources, dependent: :destroy

  has_many :repocops, foreign_key: 'srcname', primary_key: 'name'
  has_one :repocop_patch, foreign_key: 'name', primary_key: 'name'

  has_one :builder, class_name: 'Maintainer', foreign_key: 'id',
                    primary_key: 'builder_id'

  after_create :increment_branch_counter
  after_destroy :decrement_branch_counter

  def to_param
    name
  end

  def acls
    if Redis.current.exists("#{ branch.name }:#{ name }:acls")
      Maintainer.where(login: Redis.current.smembers("#{ branch.name }:#{ name }:acls"))
                .order(:name).select('login').map(&:login).join(',')
    end
  end

  def self.import(branch, file)
    srpm = Srpm.new
    srpm.name = `export LANG=C && rpm -qp --queryformat='%{NAME}' #{ file }`
    srpm.version = `export LANG=C && rpm -qp --queryformat='%{VERSION}' #{ file }`
    srpm.release = `export LANG=C && rpm -qp --queryformat='%{RELEASE}' #{ file }`
    srpm.epoch = `export LANG=C && rpm -qp --queryformat='%{EPOCH}' #{ file }`
    # TODO: make test for this
    srpm.epoch = nil if srpm.epoch == '(none)'
    srpm.filename = "#{ srpm.name }-#{ srpm.version }-#{ srpm.release }.src.rpm"

    group_name = `export LANG=C && rpm -qp --queryformat='%{GROUP}' #{ file }`
    Group.import(branch, group_name)
    group = Group.in_branch(branch, group_name)

    Maintainer.import(`export LANG=C && rpm -qp --queryformat='%{PACKAGER}' #{ file }`)

    srpm.group_id = group.id
    srpm.groupname = group_name
    srpm.summary = `export LANG=C && rpm -qp --queryformat='%{SUMMARY}' #{ file }`
    # TODO: test for this
    # HACK: for very long summary in openmoko_dfu-util src.rpm
    srpm.summary = 'Broken' if srpm.name == 'openmoko_dfu-util'
    srpm.license = `export LANG=C && rpm -qp --queryformat='%{LICENSE}' #{ file }`
    srpm.url = `export LANG=C && rpm -qp --queryformat='%{URL}' #{ file }`
    # TODO: make test for this
    srpm.url = nil if srpm.url == '(none)'
    srpm.description = `export LANG=C && rpm -qp --queryformat='%{DESCRIPTION}' #{ file }`
    srpm.vendor = `export LANG=C && rpm -qp --queryformat='%{VENDOR}' #{ file }`
    srpm.distribution = `export LANG=C && rpm -qp --queryformat='%{DISTRIBUTION}' #{ file }`
    srpm.buildtime = Time.at(`export LANG=C && rpm -qp --queryformat='%{BUILDTIME}' #{ file }`.to_i)
    srpm.size = File.size(file)
    srpm.md5 = `/usr/bin/md5sum #{ file }`.split[0]
    srpm.branch_id = branch.id
    srpm.changelogtime = Time.at(`export LANG=C && rpm -qp --queryformat='%{CHANGELOGTIME}' #{ file }`.to_i)

    changelogname = `export LANG=C && rpm -qp --queryformat='%{CHANGELOGNAME}' #{ file }`
    srpm.changelogname = changelogname

    srpm.changelogtext = `export LANG=C && rpm -qp --queryformat='%{CHANGELOGTEXT}' #{ file }`

    email = srpm.changelogname.chop.split('<')[1].split('>')[0] rescue nil

    if email
      email.downcase!
      email = Maintainer.new.fix_maintainer_email(email)
      Maintainer.import_from_changelogname(changelogname)
      maintainer = Maintainer.where(email: email).first
      srpm.builder_id = maintainer.id
    end

    if srpm.save
      Redis.current.set("#{ branch.name }:#{ srpm.filename }", 1)
      Changelog.import(file, srpm)
      Specfile.import(file, srpm)
      Patch.import(file, srpm)
      Source.import(file, srpm)
    else
      Rails.logger.info("#{ Time.now }: failed to update '#{ srpm.filename }'")
    end
  end

  def self.import_all(branch, path)
    Dir.glob(path).each do |file|
      unless Redis.current.exists("#{ branch.name }:#{ File.basename(file) }")
        next unless File.exist?(file)
        next unless Rpm.check_md5(file)
        Rails.logger.info("#{ Time.now }: import '#{ File.basename(file) }'")
        Srpm.import(branch, file)
      end
    end
  end

  def self.remove_old(branch, path)
    branch.srpms.each do |srpm|
      # FIXME: use ruby for path building
      unless File.exist?("#{ path }#{ srpm.filename }")
        srpm.packages.each do |package|
          Rails.logger.info("#{ Time.now }: delete '#{ package.filename }' from redis cache")
          Redis.current.del("#{ branch.name }:#{ package.filename }")
        end
        Rails.logger.info("#{ Time.now }: delete '#{ srpm.filename }' from redis cache")
        Redis.current.del("#{ branch.name }:#{ srpm.filename }")
        Rails.logger.info("#{ Time.now }: delete acls for '#{ srpm.filename }' from redis cache")
        Redis.current.del("#{ branch.name }:#{ srpm.name }:acls")
        Redis.current.del("#{ branch.name }:#{ srpm.name }:leader")
        srpm.destroy
      end
    end
  end

  def self.contributors(branch, srpm)
    logins = []
    branch.srpms.where(name: srpm.name).first.changelogs.each do |changelog|
      name = changelog.changelogname.split('<')[0].chomp
      name.strip!
      email = changelog.changelogname.chop.split('<')[1]
      next if email.nil?
      email.downcase!
      email = Maintainer.new.fix_maintainer_email(email)
      login = email.split('@')[0]
      logins << login
    end
    Maintainer.where(login: logins.sort.uniq).order(:name)
  end

  private

  def increment_branch_counter
    branch.counter.increment
  end

  def decrement_branch_counter
    branch.counter.decrement
  end
end
