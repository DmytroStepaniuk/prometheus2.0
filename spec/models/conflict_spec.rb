require 'spec_helper'

describe Conflict do
  it { should validate_presence_of :package_id }
  it { should validate_presence_of :name }
end
