class DowngradesController < ApplicationController

  def new
  end

  def create
    # downgrade role
    current_user.update_attributes(role:'standard')
    
    # change private wikis to public
    private_wikis = current_user.wikis.find_by(private: true)
    if private_wikis
     private_wikis.update_attributes(private: false)
    end
    
    # refund if applicable
    if current_user.refundable?
      ch = Stripe::Charge.retrieve(current_user.upgrade_charge_id)
      refund = ch.refunds.create
      flash[:alert] = "Your account has been downgraded to standard and a refund has been processed."
    else
      flash[:alert] = "Your account has been downgraded to standard with no refund."
    end
    
    # back to wikis
    redirect_to wikis_path
  end

end