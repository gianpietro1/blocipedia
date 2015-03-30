require 'rails_helper'
require 'stripe_mock'

describe ChargesController do

  include Devise::TestHelpers

  before do
    @user = create(:user)
    sign_in @user
    StripeMock.start
      @customer = Stripe::Customer.create(
        :email => @user.email,
        :card => 'valid_card_token'
      )
  end

  describe '#create' do
    it "creates a new charge for the current user" do
      expect( @user.role ).to eq 'standard'
      
      post :create, :charge => {customer: @customer.id}

      @user.reload
      expect( @user.role ).to eq 'premium'
    end
  end

end