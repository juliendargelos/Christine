class Order < ActiveRecord::Base
    include HasExtendedJson

    belongs_to :user
    has_many :purchases, autosave: true

    def as_json options = {}
        options = json_options :purchases, options
        json = base_as_json options[:base]
        json[:purchases] = purchases.map { |purchase| purchase.as_json options[:extended][:purchases] }

        json
    end

    def total_price
        total_price = 0
        purchases.each { |purchase| total_price += purchase.total_price }

        total_price
    end

    def has? product, &block
        purchases.each do |purchase|
            if purchase.product.id == product.id
                block.call purchase
                return true
            end
        end

        false
    end

    def add product
        if product.is_a? Product
            unless has? product { |purchase| purchase.quantity += 1 }
                purchases << Purchase.new(product: product)
            end

            true
        else
            false
        end
    end

    def remove product
        if product.is_a? Product
            has? product do |purchase|
                purchase.quantity -= 1
                purchases -= purchase if purchase.quantity <= 0
            end
        else
            false
        end
    end
end