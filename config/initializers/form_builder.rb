class ActionView::Helpers::FormBuilder
	def has_error? method
		@object.errors.messages.key? method
	end

	def errors method, &block
		if has_error? method
			errors = @object.errors.messages[method]
		else
			errors = []
		end

		html = ''

		if block_given?
			errors.each do |error|
				html += block.call error.ucfirst
			end

			html.html_safe
		else
			errors.map { |error| error.ucfirst }
		end
	end

	def error method, &block
		errors = errors method
		error = errors.length == 0 ? nil : errors[0]

		if error == nil
			''
		elsif block_given?
			block.call error.ucfirst
		else
			error.ucfirst
		end
	end

	def error_tag method, options = {}
		error method do |error|
			error_tag_for error, options
		end
	end

	def error_tags method, options = {}
		errors method do |error|
			error_tag_for error, options
		end
	end

	alias_method :base_label, :label

	private
		def error_tag_for e, options
			tag_name = options.key?(:tag) ? options[:tag] : :span
			options.delete :tag
			options[:class] = :error unless options.key? :class

			html = "<#{tag_name}"
			options.each do |attribute, value|
				html += " #{attribute.to_s}=\"#{value.to_s.gsub '"', '\\"'}\""
			end
			html += ">#{CGI.escapeHTML e}</#{tag_name}>"

			html.html_safe
		end
end
