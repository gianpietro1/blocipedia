require 'rails_helper'

feature 'User visits wikis' do
 
  include Warden::Test::Helpers
  Warden.test_mode!

  before do
    @user1 = create(:user)
    @user2 = create(:user)
    login_as(@user1, :scope => :user)
    @wiki1user1 = create(:wiki, user: @user1, private: false)    
    @wiki2user1 = create(:wiki, user: @user1, private: false)
    @wiki1user2 = create(:wiki, user: @user2, private: false)
  end
  
  scenario 'Successfully' do
    visit wikis_path
    within('#public_wikis') do
      expect(page).to have_content(@wiki1user1.title, @wiki2user1.title, @wiki1user2.title)
    end
    within('#my_wikis') do
      expect(page).to have_content(@wiki1user1.title, @wiki2user1.title)
    end
  end

end