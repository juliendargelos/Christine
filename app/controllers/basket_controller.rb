class BasketController < ApplicationController
	before_action :authorize
	skip_before_action :verify_authenticity_token, only: [:add, :remove]
	before_action :set_product, only: [:add, :remove]

	def show
		render json: { status: true, basket: current_user.basket.as_json(json_options) }
	end

	def add
		if current_user.basket.add @product
			current_user.basket.save
			render json: {
				status: true,
				message: I18n.t(:product_added_to_basket),
				basket: current_user.basket.as_json(json_options)
			}
		else
			render json: {
				status: false,
				message: I18n.t(:product_doesnt_exist)
			}
		end
    end

    def remove
		if current_user.basket.remove @product
			current_user.basket.save
			render json: {
				status: true,
				message: I18n.t(:product_removed_from_basket),
				basket: current_user.basket.as_json(json_options)
			}
		else
			render json: {
				status: false,
				message: I18n.t(:product_doesnt_exist)
			}
		end
    end

	def clear
		current_user.basket.purchases = []
		render json: {
			status: true,
			message: I18n.t(:basket_cleared),
			basket: current_user.basket.as_json(json_options)
		}
	end

	private
		def basket_params
			params.permit(:product_id)
		end

		def set_product
			@product = Product.find_by(id: basket_params[:product_id])
		end

		def json_options
			{
				only: true,
				purchases: {
					only: :quantity,
					product: {
						only: [:id, :name, :price],
						attachments: {
							only: :file,
							file: {
								only: :url,
								url: :thumb
							}
						}
					}
				}
			}
		end
end
