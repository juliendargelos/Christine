class ActiveRecord::Base
	def m attribute, type = :invalid, options = {}
		errors.generate_message(attribute, type, options)
	end
end
