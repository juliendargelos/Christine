class BasketController < ApplicationController
	before_action :authorize
	before_action :set_product, only: [:add, :remove]

	def show
		respond_to do |format|
			format.json do
				render json: { status: true, basket: current_user.basket.as_json(json_options) }
			end
		end
	end

	def add
        respond_to do |format|
            format.json do
                if current_user.basket.add @product
                    curent_user.basket.save
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
        end
    end

    def remove
        respond_to do |format|
            format.json do
                if current_user.basket.remove @product
                    curent_user.basket.save
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
        end
    end

	private
		def basket_params
			params.permit(:product_id)
		end

		def set_product
			@product = Product.find(basket_params[:product_id])
		end

		def json_options
			{
				only: true,
				purchases: {
					only: :quantity,
					product: {
						only: [:name, :price],
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
