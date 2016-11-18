module ProductsHelper
	def setup_product product, ammount =  1
		ammount.times { product.attachments.build }
    	product
	end

	def form_for_product record, options = {}, &block
		setup_product record

		form_for record, options, &block
	end
end
