require 'rails_helper'

context "when creating users" do

  describe "validate default for role" do
      it "will check if standard" do
        user = create(:user)
        expect( user.role ).to eq "standard"
      end
  end

end

context "when using self method" do

  describe "admin" do
      it "will return true if admin" do
        user = create(:user, role: "admin")
        expect( user.admin? ).to eq true

        user = create(:user, role: "standard")
        expect( user.admin? ).to eq false
      end
  end

  describe "premium" do
      it "will return true if premium" do
        user = create(:user, role: "premium")
        expect( user.premium? ).to eq true

        user = create(:user, role: "standard")
        expect( user.premium? ).to eq false
      end
  end

end