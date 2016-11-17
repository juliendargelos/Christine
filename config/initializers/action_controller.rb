class ActionController::Base
	before_action :store_current

	private
		def store_current
			Thread.current[:controller_name] = controller_name
			Thread.current[:action_name] = action_name
			puts Thread
		end
end
