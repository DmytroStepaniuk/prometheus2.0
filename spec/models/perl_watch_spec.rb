require 'rails_helper'

describe PerlWatch do
  describe 'Validation' do
    it { should validate_presence_of :name }
  end

  it 'should import data from CPAN' do
    page = `cat spec/data/02packages.details.txt`
    url = 'http://www.cpan.org/modules/02packages.details.txt'
    FakeWeb.register_uri(:get,
                         url,
                         response: page)
    expect {
      PerlWatch.import_data(url)
    }.to change { PerlWatch.count }.from(0).to(1)
    PerlWatch.count.should eq(1)
    perlwatch = PerlWatch.first
    perlwatch.name.should eq('AnyEvent::ZeroMQ')
    perlwatch.version.should eq('0.01')
    perlwatch.path.should eq('J/JR/JROCKWAY/AnyEvent-ZeroMQ-0.01.tar.gz')
  end
end
