require 'rails_helper'

feature 'User visits wikis' do
 
  include Warden::Test::Helpers
  Warden.test_mode!

  before do
    @user = create(:user)
    login_as(@user, :scope => :user)
    @wiki1 = create(:wiki, user: @user)    
    @wiki2 = create(:wiki, user: @user)
  end
  
  scenario 'Successfully' do
    visit wikis_path
    expect(page).to have_content(@wiki1.title)
    expect(page).to have_content(@wiki2.title)
  end

end