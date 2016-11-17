module UsersHelper
	def form_for_user record, options = {}, &block
		if options[:url] == nil
			options[:url] = {
				controller: controller_name,
				action: [:new, :create].include?(action_name) ? :create : :update
			}
		end

		form_for record, options, &block
	end
end
