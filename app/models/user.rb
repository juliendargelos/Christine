# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string
#  password_digest :string
#  firstname       :string
#  lastname        :string
#  birthdate       :date
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ActiveRecord::Base
	has_secure_password
	has_many :orders

	validates :email, presence: true, email: true, uniqueness: true
	validates :password, presence: true, length: { minimum: 6 }, confirmation: true, on: :create
	validates :firstname, presence: true
	validates :lastname, presence: true
	validates :birthdate, presence: true, birthdate: { minimum_age: 18, maximum_age: 120 }

	def basket
		@basket = Order.find_by(user_id: id, done: false) || Order.new(user_id: id) if @basket == nil
		@basket
	end

	def self.birthdate_boundaries
		options = validators_on(:birthdate)[1].options
		min = Date.today - options[:minimum_age].years
		max = Date.today - options[:maximum_age].years

		{
			start_year: min.year,
			end_year: max.year
		}
	end

	def self.admins
		self.where(admin: true)
	end
end
