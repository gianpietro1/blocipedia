require 'rails_helper'

context "when creating wikis" do

  before do
    @valid_title = "A title with more than five characters"
    @invalid_title = "No"
    @valid_body = "A body with more than 20 characters"
    @invalid_body = "No"
    @user = create(:user)
  end

  describe "validates title" do
      it "will allow 5 or more characters" do
        wiki = Wiki.new(title: @valid_title, body: @valid_body, user: @user)
        expect( wiki.valid? ).to eq true

        wiki = Wiki.new(title: @invalid_title, body: @valid_body, user: @user)
        expect( wiki.valid? ).to eq false
      end
  end

  describe "validate body" do
      it "will allow 20 or more characters" do
        wiki = Wiki.new(title: @valid_title, body: @valid_body, user: @user)
        expect( wiki.valid? ).to eq true

        wiki = Wiki.new(title: @valid_title, body: @invalid_body, user: @user)
        expect( wiki.valid? ).to eq false
      end
  end

  describe "validate user" do
      it "will check if present" do
        wiki = Wiki.new(title: @valid_title, body: @valid_body, user: @user)
        expect( wiki.valid? ).to eq true

        wiki = Wiki.new(title: @valid_title, body: @valid_body, user: nil)
        expect( wiki.valid? ).to eq false
      end
  end

  describe "validate default for private" do
      it "will check if public" do
        wiki = build(:wiki)
        allow(wiki).to receive(:set_tags)
        wiki.save
        expect( wiki.private ).to eq false
      end
  end

end

context "when using self method" do

 before do
    @user_owner = create(:user)
    @user_collaborator = create(:user)
    @user_other = create(:user)
    @wiki = build(:wiki, user_id: @user_owner.id, id: 999)
    allow(@wiki).to receive(:set_tags)
    @wiki.save
    collaborator = create(:collaboration, wiki_id: @wiki.id, user_id: @user_collaborator.id)
  end

  describe "public" do
      it "will return true if public" do
        wiki = build(:wiki)
        allow(wiki).to receive(:set_tags)
        wiki.save
        expect( wiki.public? ).to eq true

        wiki = build(:wiki, private: true)
        allow(wiki).to receive(:set_tags)
        wiki.save
        expect( wiki.public? ).to eq false
      end
  end

  describe "users" do
 
      it "will return a list of collaborators including the owner" do
      
        expect( @wiki.users ).to include @user_owner
        expect( @wiki.users ).to include @user_collaborator

      end
  end

  describe "collaborators" do
 
      it "will return a list of collaborators not including the owner" do

        expect( @wiki.collaborators ).to include @user_collaborator
        expect( @wiki.collaborators ).not_to include @user_owner

      end
  end

  describe "all_tags setter & getter" do
 
      it "will set and tags for current wiki" do

        @wiki1 = build(:wiki)
        @wiki1.all_tags=(["tag1","tag2","tag3"]) 
        @wiki1.save
        expect( @wiki1.all_tags.split(",") ).to match_array(["tag1","tag2","tag3"])

        @wiki1.all_tags=(["tag1","tag2"]) 
        @wiki1.save
        expect( @wiki1.all_tags.split(",") ).to match_array(["tag1","tag2"])

        @wiki1.all_tags=([])
        @wiki1.save
        expect( @wiki.all_tags.split(",")  ).to match_array([])

        @wiki1.all_tags=(["tag1","tag2","tag3","tag4"])
        @wiki1.save
        expect( @wiki1.all_tags.split(",")  ).to match_array(["tag1","tag2","tag3","tag4"])

        $redis.del(@wiki1.id)

    end

  end

  describe "search tags" do

    before do
        @wiki1 = build(:wiki)
        allow(@wiki1).to receive(:set_tags)
        @wiki1.save
        @wiki2 = build(:wiki)
        @wiki2.all_tags=(["tag23"]) 
        @wiki2.save
        @wiki3 = build(:wiki)
        @wiki3.all_tags=(["tag23"]) 
        @wiki3.save
    end

 
      it "will retrieve wikis according to tag" do
        
        @wikis = Wiki.search("tag23")
        expect( @wikis ).not_to include(@wiki1) 
        expect( @wikis ).to include(@wiki2)
        expect( @wikis ).to include(@wiki3)

    end

  end

end



 