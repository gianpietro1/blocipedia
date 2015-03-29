class ChargesController < ApplicationController

  def create
    # Creates a Stripe Customer object, for associating with the charge
    customer = Stripe::Customer.create(
     email: current_user.email,
     card: params[:stripeToken]
   )
 
   # Where the real magic happens
   charge = Stripe::Charge.create(
     customer: customer.id,
     amount: Amount.default,
     description: "BigMoney Membership - #{current_user.email}",
     currency: 'usd'
   )

   # After successful payment:
   # Store charge.id
   current_user.update_attributes(upgrade_charge_id:charge.id)
   # Upgrade role
   current_user.update_attributes(role:'premium')
   # Populate upgrade date
   current_user.update_attributes(upgrade_date: Time.now)
   # Back to wikis with the flash
   flash[:notice] = "Thanks for your payment #{current_user.email}! Enjoy your premium status."
   redirect_to wikis_path

   # Stripe will send back CardErrors, with friendly messages
   # when something goes wrong.
   # This `rescue block` catches and displays those errors.
   rescue Stripe::CardError => e
     flash[:error] = e.message
     redirect_to new_charge_path

  end

  def new
   @stripe_btn_data = {
     key: "#{ Rails.configuration.stripe[:publishable_key] }",
     description: "BigMoney Membership - #{current_user.name}",
     amount: Amount.default
   }
  end

  def downgrade
  end

  def downgrade_proceed
   if current_user.refundable?
    charge = Stripe::Charge.retrieve(current_user.upgrade_charge_id)
    charge.refund
   end
   flash[:notice] = "Your account has been downgraded to standard."
   current_user.update_attributes(role:'standard')
   redirect_to wikis_path
  end

end
