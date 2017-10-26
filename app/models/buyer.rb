class Buyer < ApplicationRecord
  validates :name, :email, :phone, :address, presence: true
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_format_of :phone, :with => /\A[-+]?[0-9]*\.?[0-9]+\Z/i
  validates :phone, length: { maximum: 12 }

  def self.by_letter(letter)
    return nil if letter.nil?
    where("name LIKE ?", "#{letter}%").order(:name)
  end
end
