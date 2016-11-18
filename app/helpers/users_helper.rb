module UsersHelper
	def form_for_user record, options = {}, &block
		if options[:url] == nil
			options[:url] = {
				controller: controller_name,
				action: action_is?(:new, :create) ? :create : :update
			}
		end

		form_for record, options, &block
	end
end
