require 'rails_helper'

context "validations" do

  before do
    @valid_title = "A title with more than five characters"
    @invalid_title = "No"
    @valid_body = "A body with more than 20 characters"
    @invalid_body = "No"
    @user = create(:user)
  end

  describe "title" do
      it "allows 5 or more characters" do
        wiki = Wiki.new(title: @valid_title, body: @valid_body, user: @user)
        expect( wiki.valid? ).to eq true

        wiki = Wiki.new(title: @invalid_title, body: @valid_body, user: @user)
        expect( wiki.valid? ).to eq false
      end
  end

  describe "body" do
      it "allows 20 or more characters" do
        wiki = Wiki.new(title: @valid_title, body: @valid_body, user: @user)
        expect( wiki.valid? ).to eq true

        wiki = Wiki.new(title: @valid_title, body: @invalid_body, user: @user)
        expect( wiki.valid? ).to eq false
      end
  end

  describe "user" do
      it "should be present" do
        wiki = Wiki.new(title: @valid_title, body: @valid_body, user: @user)
        expect( wiki.valid? ).to eq true

        wiki = Wiki.new(title: @valid_title, body: @valid_body, user: nil)
        expect( wiki.valid? ).to eq false
      end
  end

end