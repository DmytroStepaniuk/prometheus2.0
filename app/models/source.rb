class Source < ActiveRecord::Base
  belongs_to :srpm

  validates :srpm, presence: true
  validates :filename, presence: true
  validates :size, presence: true

  def self.import(file, srpm)
    files = `rpmquery --qf '[%{BASENAMES}\t%{FILESIZES}\n]' -p #{ file }`
    hsh = {}
    files.split("\n").each do |line|
      hsh[line.split("\t")[0]] = line.split("\t")[1]
    end
    sources = `rpmquery --qf '[%{SOURCE}\n]' -p #{ file }`
    sources.split("\n").each do |filename|
      source = Source.new

      # DON'T import source if size is more than 512k
      if hsh[filename].to_i <= 1024 * 512
        content = `rpm2cpio "#{ file }" | cpio -i --quiet --to-stdout "#{ filename }"`
        source.source = content.force_encoding('BINARY')
      end

      source.size = hsh[filename].to_i
      source.filename = filename
      source.srpm_id = srpm.id
      source.save!
    end
  end

  def to_param
    filename
  end
end
