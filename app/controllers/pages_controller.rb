class PagesController < ApplicationController
	def home
		@products = Product.take 9
	end
end
