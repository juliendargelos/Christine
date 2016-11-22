# == Schema Information
#
# Table name: products
#
#  id          :integer          not null, primary key
#  name        :string
#  price       :integer
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  baseline    :string
#

class Product < ActiveRecord::Base
	include HasExtendedJson

	has_many :attachments, dependent: :destroy
	has_many :purchases

	accepts_nested_attributes_for :attachments, reject_if: proc { |attr| attr.all? { |k, v| v.blank? } }, allow_destroy: true

	validates :name, presence: true
	validates :price, presence: true, numericality: { greater_than: 0 }
	validates :baseline, presence: true
	validates :description, presence: true

	def plain_price
		(price/100).to_s+Product.currency[:symbol]
	end

	def as_json options = {}
		options = json_options :attachments, options
		json = base_as_json options[:base]
		json[:attachments] = attachments.map { |attachment| attachment.as_json options[:extended][:attachments] }

		json
	end

	def self.currency
		{
			identifier: 'eur',
			symbol: '€'
		}
	end
end
