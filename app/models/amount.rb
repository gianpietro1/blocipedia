class Amount < ActiveRecord::Base

  def self.default
    return 10_00
  end

end