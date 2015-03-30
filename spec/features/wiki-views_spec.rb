require 'rails_helper'

feature 'User visits wikis' do
 
  include Warden::Test::Helpers
  Warden.test_mode!

  before do
    @user1 = create(:user)
    @user2 = create(:user)
    login_as(@user1, :scope => :user)
    @wiki1user1 = create(:wiki, user: @user1)    
    @wiki2user1 = create(:wiki, user: @user1)
    @wiki1user2 = create(:wiki, user: @user2)
  end
  
  scenario 'Successfully' do
    visit wikis_path
    within('#public_wikis') do
      expect(page).to have_content(@wiki1user1.title)
      expect(page).to have_content(@wiki2user1.title)
      expect(page).to have_content(@wiki1user2.title)
    end
    within('#my_wikis') do
      expect(page).to have_content(@wiki1user1.title)
      expect(page).to have_content(@wiki2user1.title)
    end
  end

end

feature 'User creates wikis' do
 
  include Warden::Test::Helpers
  Warden.test_mode!

  before do
    @user = create(:user)
    login_as(@user, :scope => :user)
  end
  
  scenario 'Successfully public' do
    visit new_wiki_path
    fill_in 'Title', with: 'This is a title'
    fill_in 'Body', with: 'This is the long long long body'
    click_button 'Save'
    expect(page).to have_content('Wiki was saved.')
  end

end

feature 'User shows wiki' do
 
  include Warden::Test::Helpers
  Warden.test_mode!

  before do
    @user = create(:user)
    login_as(@user, :scope => :user)
    @wiki = create(:wiki, user: @user)    
  end
  
  scenario 'Successfully public' do
    visit wiki_path(@wiki)
    expect(page).to have_content(@wiki.title)
    expect(page).to have_content(@wiki.body)
  end

end

feature 'User edits wiki' do
 
  include Warden::Test::Helpers
  Warden.test_mode!

  before do
    @user = create(:user)
    login_as(@user, :scope => :user)
    @wiki = create(:wiki, user: @user)    
    @updated_body = "A body with more than 20 characters, updated."
  end
  
  scenario 'Successfully public' do
    visit edit_wiki_path(@wiki)
    expect(page).to have_content(@wiki.body)
    fill_in 'Body', with: @updated_body
    click_button 'Save'
    visit edit_wiki_path(@wiki)
    expect(page).to have_content(@updated_body)
  end

end