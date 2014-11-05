require 'spec_helper'

describe MaintainerDecorator do
  it 'should return gravatar url for maintainer email' do
    expect(Maintainer.new(email: 'icesik@altlinux.org').decorate.avatar_url)
      .to eq('http://gravatar.com/avatar/6b747716cf92a45179b30030d8725ac3.png?s=420&r=g')
  end

  it 'should return gravatar url for maintainer email (second case)' do
    expect(Maintainer.new(email: 'ICESIK@ALTLINUX.ORG').decorate.avatar_url)
      .to eq('http://gravatar.com/avatar/6b747716cf92a45179b30030d8725ac3.png?s=420&r=g')
  end
end
