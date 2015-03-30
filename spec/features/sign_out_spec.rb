require 'rails_helper'

include Warden::Test::Helpers

describe 'Sign out' do
  it 'should successfully sign out user' do
    user = create(:user_confirmed)
    branch = create(:branch, name: 'Sisyphus', vendor: 'ALT Linux')
    login_as user

    visit '/'

    click_link 'Sign out'
    expect(page).to have_content('Signed out successfully.')
  end
end

=begin
Feature: User sign out
  To protect my account from unauthorized access
  A signed in user
  Should be able to sign out

  Background:
    Given we have branch "Sisyphus"

  Scenario: User sign out
    Given I am signed up and confirmed as "email@person.com"
    When I sign in as "email@person.com"
    Then I should see "Welcome, email@person.com!"
    And I sign out
    Then I should see "Signed out successfully."
=end
