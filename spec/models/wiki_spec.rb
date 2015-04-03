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
        wiki = create(:wiki)
        expect( wiki.private ).to eq false
      end
  end

end

context "when using self method" do

 before do
    @user_owner = create(:user)
    @user_collaborator = create(:user)
    @user_other = create(:user)
    @wiki = create(:wiki, user_id: @user_owner.id)
    collaborator = create(:collaboration, wiki_id: @wiki.id, user_id: @user_collaborator.id)
  end

  describe "public" do
      it "will return true if public" do
        wiki = create(:wiki)
        expect( wiki.public? ).to eq true

        wiki = create(:wiki, private: true)
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

        expect( @wiki.tags ).to be_empty

        @wiki.all_tags = "tag1,tag2,tag3"

        expect( @wiki.all_tags ).to eq "tag1, tag2, tag3"
        expect( @wiki.tags.first.name ).to eq "tag1"
        expect( @wiki.tags.last.name ).to eq "tag3"

        @wiki.all_tags = "tag1,tag2 tag3"

        expect( @wiki.all_tags ).to eq "tag1, tag2 tag3"
        expect( @wiki.tags.first.name ).to eq "tag1"
        expect( @wiki.tags.last.name ).to eq "tag2 tag3"

    end

  end

  describe "search tags & title" do

    before do
        @wiki1 = create(:wiki, title: "Wiki 1")
        @wiki2 = create(:wiki, title: "Wiki 2")
        @wiki3 = create(:wiki, title: "Wiki 3")
        @wiki2.all_tags = "tag23" 
        @wiki3.all_tags = "tag23" 
    end

 
      it "will retrieve wikis according to search term" do

        @wikis = Wiki.search("Wiki 1")
        expect( @wikis ).to include(@wiki1) 
        expect( @wikis ).not_to include(@wiki2)
        expect( @wikis ).not_to include(@wiki3)
        
        @wikis = Wiki.search("tag23")
        expect( @wikis ).not_to include(@wiki1) 
        expect( @wikis ).to include(@wiki2)
        expect( @wikis ).to include(@wiki3)

    end

  end

end



 