require 'rails_helper'

describe CollaborationsController do

  include Devise::TestHelpers

  before do
    @user = create(:user, role: 'premium')
    @wiki = create(:wiki, user: @user, private: true)
    sign_in @user
  end

  describe '#create' do
          
    it "adds a collaborator" do
      
      @wiki = create(:wiki)
      expect(@wiki.collaborations.first.user_id).to eq @wiki.user_id

      post :create, wiki_id: @wiki.id, :user_ids => [10, 20, 30, 40]

      expect(@wiki.collaborations.last.user_id).to eq 40

    end
    
  end

  describe '#destroy' do
          
    it "removes a collaborator" do

      @wiki = create(:wiki)
      expect(@wiki.collaborations.last.user_id).to eq @wiki.user.id

      @wiki.collaborations.create(user_id: 10)
      @wiki.collaborations.create(user_id: 40)
      expect(@wiki.collaborations.last.user_id).to eq 40

      delete :destroy, wiki_id: @wiki.id, :user_ids => [10, 40]

      expect(@wiki.collaborations.last.user_id).to eq @wiki.user.id

    end
    
  end

end