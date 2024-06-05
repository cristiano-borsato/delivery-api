class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product
  belongs_to :order, inverse_of: :order_items

  validate :store_product

  private

  def store_product
    if product.store != order.store
      errors.add(
      :product,
      "product should belong to 'Store': #{order.store.name}"
      )
    end
  end

end
