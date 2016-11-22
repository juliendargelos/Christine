# == Schema Information
#
# Table name: purchases
#
#  id         :integer          not null, primary key
#  product_id :integer
#  order_id   :integer
#  quantity   :integer          default(1)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Purchase < ActiveRecord::Base
    include HasExtendedJson

    after_initialize :set_quantity

    has_one :user, through: :order
    belongs_to :product
    belongs_to :order

    validates :product, presence: true
    validates :quantity, numericality: { only_integer: true, greater_than: 0 }

    def as_json options = {}
        options = json_options :product, options
        json = base_as_json options[:base]
        json[:plain_total_price] = plain_total_price
        json[:product] = product.as_json options[:extended][:product]

        json
    end

    def total_price
        product.price*quantity
    end

    def plain_total_price
        (total_price/100).to_s+Product.currency[:symbol]
    end

    private
        def set_quantity
            self.quantity ||= 1
        end
end
