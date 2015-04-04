require 'rails_helper'

feature 'User signs up' do
 
  scenario 'Successfully' do
    visit root_path
    click_link 'Sign Up'
    fill_in 'Username', with: 'user'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    fill_in 'Email', with: 'user@example.com'
    click_button 'Sign up'
    expect(page).to have_content('A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.')
  end

end

feature 'User signs in' do

  before do
    @user = create(:user)
  end
 
  scenario 'Successfully' do
    visit root_path
    click_link 'Sign In'
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password
    click_button 'Sign in'
    expect(page).to have_content(' Signed in successfully.')
  end

end 

feature 'User signs out' do

  include Warden::Test::Helpers
  Warden.test_mode!

  before do
    @user = create(:user)
    login_as(@user, :scope => :user)
  end
 
  scenario 'Successfully' do
    visit root_path
    click_link('sign-out')
    expect(page).to have_content(' Signed out successfully.')
  end

end