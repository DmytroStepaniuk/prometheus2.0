require 'rails_helper'

describe Bug do
  it { should have_db_index :assigned_to }
  it { should have_db_index :bug_status }
  it { should have_db_index :product }

  it 'should import bugs from url' do
    bugs = `cat spec/data/bugs.csv`
    cmd = 'curl --silent "https://bugzilla.altlinux.org/buglist.cgi?ctype=csv"'
    Bug.should_receive(:`).with(cmd).and_return(bugs)
    Bug.import('https://bugzilla.altlinux.org/buglist.cgi?ctype=csv')
    Bug.count.should eq(1)
    bug = Bug.first
    bug.bug_id.should eq(22_555)
    bug.bug_status.should eq('CLOSED')
    bug.resolution.should eq('FIXED')
    bug.bug_severity.should eq('blocker')
    bug.product.should eq('Sisyphus')
    bug.component.should eq('openbox')
    bug.assigned_to.should eq('icesik@altlinux.org')
    bug.reporter.should eq('user@email.com')
    bug.short_desc.should eq('segfault')
  end
end
