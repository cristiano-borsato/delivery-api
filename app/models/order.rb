class Order < ApplicationRecord
  belongs_to :buyer, class_name: "User"
  belongs_to :store
  has_many :order_items
  has_many :products, through: :order_items
  has_many :order_items, inverse_of: :order
  accepts_nested_attributes_for :order_items, reject_if: :all_blank, allow_destroy: true

  validate :buyer_role

  state_machine initial: :created do
    event :accept do
      transition created: :accepted
    end
  end

  private

  def buyer_role
    if !buyer.buyer?
      errors.add(:buyer, "should be a 'user.buyer'")
    end
  end
end