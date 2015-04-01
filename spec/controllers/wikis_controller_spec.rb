require 'rails_helper'

describe WikisController do

  include Devise::TestHelpers

  before do
    @valid_title = "A title with more than five characters"
    @valid_body = "A body with more than 20 characters"
    @updated_body = "A body with more than 20 characters, updated."
    @user = create(:user)
    @another_user = create(:user)
    sign_in @user
  end

  describe '#create' do
    it "creates a new wiki for the current user and adds it as collaborator" do
      expect( @user.wikis ).to be_empty

      post :create, :wiki => {title: @valid_title, body: @valid_body}

      expect( @user.wikis ).not_to be_nil      

      expect( @user.wikis.first.users ).to include(@user)      

    end

    it "creates a new collaborator (owner)" do
      
      post :create, :wiki => {title: @valid_title, body: @valid_body}

      expect( @user.wikis ).not_to be_nil      
    end
  end

  describe '#destroy' do
    
    context 'own wikis' do
      it "destroys a wiki for the current user" do
        wiki = create(:wiki, user: @user)
        expect( @user.wikis ).not_to be_empty 

        delete :destroy, :id => wiki.id

        expect( @user.wikis.find_by_id(wiki.id) ).to be_nil      
      end
    end

    context 'others wikis' do
      it "can't destroy a wiki from another user" do
        wiki = create(:wiki, user: @another_user)
        expect( @another_user.wikis ).not_to be_empty 

        delete :destroy, :id => wiki.id

        expect( @another_user.wikis.find_by_id(wiki.id) ).not_to be_nil      
      end
    end    

  end

  describe '#update' do
    context 'own wikis' do
      it "updates a wiki" do
        wiki = create(:wiki, title: @valid_title, body: @valid_body)
        expect( wiki.body ).to eq(@valid_body)

        put :update, :id => wiki.id , :wiki => {title: @valid_title, body: @updated_body}
        
        wiki.reload
        expect( wiki.body ).to eq(@updated_body)
      end
    end

    context 'others public wikis' do
      it "updates a wiki" do
        wiki = create(:wiki, title: @valid_title, body: @valid_body, user: @another_user)
        expect( wiki.body ).to eq(@valid_body)

        put :update, :id => wiki.id , :wiki => {title: @valid_title, body: @updated_body}
        
        wiki.reload
        expect( wiki.body ).to eq(@updated_body)
      end
    end

    context 'others private wikis' do
      it "does not update a wiki" do
        wiki = create(:wiki, title: @valid_title, body: @valid_body, user: @another_user, private: true)
        expect( wiki.body ).to eq(@valid_body)

        put :update, :id => wiki.id , :wiki => {title: @valid_title, body: @updated_body}
        
        wiki.reload
        expect( wiki.body ).to eq(@valid_body)
      end
    end

  end

end