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

  describe "upgrade_since_days" do
    it "will return days since upgrade if upgrade_date exists" do
      user = create(:user, upgrade_date: Time.now)
      expect( user.upgrade_since_days ).to eq 0

      user = create(:user, upgrade_date: Time.now - 10.days)
      expect( user.upgrade_since_days ).to eq 10

      user = create(:user, upgrade_date: nil)
      expect( user.upgrade_since_days ).to eq nil
    end
  end

  describe "refundable?" do
    it "will return true if less than refund limit" do
      user = create(:user, upgrade_date: Time.now)
      expect( user.refundable? ).to eq true

      user = create(:user, upgrade_date: Time.now - (user.refund_limit + 1.days))
      expect( user.refundable? ).to eq false
    end
  end 

end
