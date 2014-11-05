require 'spec_helper'

describe Gear, type: :model do
  describe 'Associations' do
    it { is_expected.to belong_to :maintainer }
    it { is_expected.to belong_to :srpm }
  end

  describe 'Validation' do
    it { is_expected.to validate_presence_of :repo }
    it { is_expected.to validate_presence_of :lastchange }
  end

  it { is_expected.to have_db_index :maintainer_id }
  it { is_expected.to have_db_index :srpm_id }

  it 'should import gear repos' do
    branch = FactoryGirl.create(:branch)

    group0 = Group.create!(name: 'System', branch_id: branch.id)
    group = Group.create!(name: 'Servers', branch_id: branch.id)
    group.move_to_child_of(group0)

    Maintainer.create!(name: 'Igor Zubkov',
                       email: 'icesik@altlinux.org',
                       login: 'icesik')

    Srpm.create!(branch_id: branch.id,
                 name: 'pulseaudio',
                 version: '1.1',
                 release: 'alt1.1',
                 summary: 'PulseAudio is a networked sound server',
                 description: 'long description',
                 group_id: group.id,
                 groupname: 'System/Servers',
                 license: 'LGPL',
                 url: 'http://pulseaudio.org/',
                 size: 10_482_200,
                 filename: 'pulseaudio-1.1-alt1.1.src.rpm',
                 md5: '602df8c1227b9b5ddf2ba87efb081007',
                 buildtime: '2011-11-17 13:48:29 UTC')

    page = `cat spec/data/people-packages-list`
    FakeWeb.register_uri(:get,
                         'http://git.altlinux.org/people-packages-list',
                         response: page)

    expect { Gear.update_gitrepos('http://git.altlinux.org/people-packages-list') }
      .to change { Gear.count }.from(0).to(1)
  end
end
