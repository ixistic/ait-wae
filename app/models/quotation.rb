class Quotation < ApplicationRecord

  def self.search(search)
    where("lower(quote) LIKE ?", "%#{search}%")
  end

end
