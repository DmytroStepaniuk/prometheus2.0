require 'spec_helper'

describe Obsolete, type: :model do
  describe 'Associations' do
    it { is_expected.to belong_to :package }
  end

  describe 'Validation' do
    it { is_expected.to validate_presence_of :package }
    it { is_expected.to validate_presence_of :name }
  end

  it { is_expected.to have_db_index :package_id }
end
