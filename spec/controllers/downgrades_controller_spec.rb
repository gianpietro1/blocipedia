require 'rails_helper'
require 'stripe_mock'

describe DowngradesController do


  include Devise::TestHelpers

  before do
    @user_new = create(:user, role: 'premium', upgrade_date: Time.now)
    @user_old = create(:user, role: 'premium', upgrade_date: Time.now - 100.days)
    @wiki_new = create(:wiki, user: @user_new, private: true)
    @wiki_old = create(:wiki, user: @user_old, private: true)

    StripeMock.start
      
      @customer = Stripe::Customer.create(
        :email => @user_new.email,
        :card => 'valid_card_token'
      )

      @charge = Stripe::Charge.create(
        customer: @customer.id,
        amount: Amount.default,
        description: "Blocipedia Membership - #{@user_new.email}",
        currency: 'usd'
      )

    @user_new.update_attributes(upgrade_charge_id: @charge.id)
      
  end

  describe '#proceed' do
    
    context 'downgrade with refund' do
      
      it "downgrades the new user from premium to standard" do
        
        expect( @user_new.role ).to eq 'premium'
        expect( @user_new.wikis.first.private ).to eq true
        
        sign_in @user_new
        
        post :proceed

        @user_new.reload

        expect( @user_new.role ).to eq 'standard'
        expect( @user_new.wikis.first.private ).to eq false
      
      end
    end

    context 'downgrade without refund' do
      
      it "downgrades the old user from premium to standard" do
        
        expect( @user_old.role ).to eq 'premium'
        expect( @user_old.wikis.first.private ).to eq true
        
        sign_in @user_old
        
        post :proceed

        @user_old.reload

        expect( @user_old.role ).to eq 'standard'
        expect( @user_old.wikis.first.private ).to eq false
      
      end
    end
  end

end