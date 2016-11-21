class Purchase < ActiveRecord::Base
    include HasExtendedJson

    after_initialize :set_quantity

    has_one :user, through: :order
    belongs_to :product
    belongs_to :order

    validates :user, presence: true
    validates :product, presence: true
    validates :quantity, numericality: { only_integer: true, greater_than: 0 }

    def as_json options = {}
        options = json_options :product, options
        json = base_as_json options[:base]
        json[:product] = product.as_json options[:extended][:product]

        json
    end

    def total_price
        product.price*quantity
    end

    private
        def set_quantity
            self.quantity ||= 1
        end
end
