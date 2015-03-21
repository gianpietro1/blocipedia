require 'rails_helper'

describe WikisController do

  include Devise::TestHelpers

  before do
    @valid_title = "A title with more than five characters"
    @valid_body = "A body with more than 20 characters"
    @updated_body = "A body with more than 20 characters, updated."
    @user = create(:user)
    sign_in @user
  end

  describe '#create' do
    it "creates a new wiki for the current user" do
      expect( @user.wikis ).to be_empty
      
      post :create, :wiki => {title: @valid_title, body: @valid_title}


      expect( @user.wikis ).not_to be_nil      
    end
  end

  describe '#destroy' do
    it "destroys a wiki for the current user" do
      wiki = create(:wiki, user: @user)
      expect( @user.wikis ).not_to be_empty

      delete :destroy, :id => wiki.id

      expect( @user.wikis.find_by_id(wiki.id) ).to be_nil      
    end
  end

  describe '#update' do
    it "updates a wiki" do
      wiki = create(:wiki, title: @valid_title, body: @valid_body)
      expect( wiki.body ).to eq(@valid_body)

      put :update, :id => wiki.id , :wiki => {title: @valid_title, body: @updated_body}
      
      wiki.reload
      expect( wiki.body ).to eq(@updated_body)
    end
  end

end