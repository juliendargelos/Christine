module ApplicationHelper
	@title = nil
	@stylesheets = []
	@javascripts = []
	@defer_routes = ''
	@defer_translations = ''

	def display_flash *handle, &block
		handle = [:notice, :success, :error] if handle.length == 0
		handle.each do |type|
			if flash.key? :"#{type}"
				block.call flash[:"#{type}"], type
				break;
			end
		end
	end

	def title content = nil
		unless content.is_a?(String) || content.is_a?(Symbol)
			params = {
				base: nil,
				delimiter: '-'
			}

			if content.is_a? Hash
				params.each do |key, value|
					params[key] = content[key] if content.key? key
					params[key] = t(params[key], default: params[key].to_s.humanize) if params[key].is_a? Symbol
				end
			end

			if @title != nil
				if params[:base] == nil
					return @title
				else
					delimiter = params[:delimiter] == nil ? ' ' : ' '+params[:delimiter]+' '
					return params[:base]+delimiter+@title
				end
			else
				return params[:base] == nil ? 'Title' : params[:base]
			end
		else
			@title = content.is_a?(Symbol) ? t(content, default: content.to_s.humanize) : content
		end
	end

	def nav_item label, route, options = {}, &block

		icon = options.key?(:icon) ? options[:icon] : nil
		selected = options.key?(:selected) ? options[:selected] : {}
		logo = options[:logo] == true
		do_block = options[:block_if] != false && block_given?

		[:icon, :selected, :logo, :block_if].each { |key| options.delete key }

		selected[:controllers] = selected[:controller] if selected.key? :controller
		selected[:actions] = selected[:action] if selected.key? :action

		if selected.key?(:controllers) || selected.key?(:actions)
			is_selected = true

			if selected.key? :controllers
				selected[:controllers] = [selected[:controllers]] unless selected[:controllers].is_a? Array
				is_selected = false unless selected[:controllers].include? :"#{controller_name}"
			end

			if selected.key? :actions
				selected[:actions] = [selected[:actions]] unless selected[:actions].is_a? Array
				is_selected = false unless selected[:actions].include? :"#{action_name}"
			end
		else
			is_selected = false
		end

		label = t(label, default: label.to_s.humanize) if label.is_a? Symbol
		label = svg(:icons, icon)+label unless icon == nil || logo
		label = svg(:logo)+label if logo

		options[:'data-toggle'] = do_block ? '' : nil

		if is_selected
			options[:class] = options[:class] == nil ? :selected : options[:class].to_s+' selected'
		end

		capture do
			concat link_to label, route, options
			concat content_tag(:div) { block.call } if do_block
		end
	end

	def body_class *classname
		if classname.length == 0
			unless @body_class == nil
				" class=#{@body_class.join ' '}"
			else
				''
			end
		else
			@body_class = [] if @body_class == nil
			@body_class += classname
		end
	end

	def svg *parts
		parts = [:images] + parts.flatten
		parts[-1] = "#{parts.last}.svg"

		path = AssetsPrecompiler.path parts

		if File.file? path
			raw File.read path
		else
			''
		end
	end

	def t_attr record, attr
		return t :"activerecord.attributes.#{record}.#{attr}"
	end

	def current_stylesheet
		stylesheet_link_tag AssetsPrecompiler.stylesheet_for(controller_name, action_name), media: :all
	end

	def current_javascript
		javascript_include_tag AssetsPrecompiler.javascript_for(controller_name, action_name)
	end

	def stylesheet file = nil, options = {}
		@stylesheets = [] unless @stylesheets.is_a? Array
		if file == nil
			capture do
				@stylesheets.each do |stylesheet|
					concat stylesheet_link_tag stylesheet[:file], stylesheet[:options]
				end
			end
		else
			@stylesheets << { file: file.to_s, options: options }
			''
		end
	end

	def javascript file = nil, options = {}
		@javascripts = [] unless @javascripts.is_a? Array
		if file == nil
			capture do
				@javascripts.each do |javascript|
					concat javascript_include_tag javascript[:file], javascript[:options]
				end
			end
		else
			@javascripts << { file: file.to_s, options: options }
			''
		end
	end

	def defer_route name, route = nil
		@defer_routes = '' if @defer_routes == nil
		if route.is_a? Hash
			if route.has_key? :js_params
				route[:js_params] = [route[:js_params]] unless route[:js_params].is_a? Array
				route[:js_params].each do |param|
					route[param] = "'+#{param}+'".html_safe
				end

				if route.has_key?(:controller) && route.has_key?(:action)
					r = '\''+url_for(route.except(:js_params))+'\''
					r = r.gsub /\+''\z/, ''
					@defer_routes += "#{name}: function(#{route[:js_params].join ','}) {return #{r};},".html_safe
				else
					r = '\''+send("#{name}_path", route.except(:js_params))+'\''
					r = r.gsub /\+''\z/, ''
					@defer_routes += "#{name}: function(#{route[:js_params].join ','}) {return #{r};},".html_safe
				end
			else
				if route.has_key?(:controller) && route.has_key?(:action)
					@defer_routes += "#{name}: '#{url_for route}',".html_safe
				else
					r = send("#{name}_path", route)
					@defer_routes += "#{name}: '#{r}',".html_safe
				end
			end

			return nil
		end

		if route == nil
			route = send("#{name}_path")
		end

		@defer_routes += "#{name}:'#{url_for route}',".html_safe
	end

	def defer_translation js_key, key = nil
		@defer_translations = '' if @defer_translations == nil
		key = js_key if key == nil
		@defer_translations += "#{js_key}: '#{t(key, {default: key.to_s.humanize}).gsub('\'', '\\\'')}',"
	end

	def defer_routes
		if @defer_routes != nil && @defer_routes != ''
			content_tag :script, type: 'text/javascript' do
				concat 'routes = {'
				concat @defer_routes.gsub(/,\z/, '').html_safe
				concat '};'
			end
		else
			''
		end
	end

	def defer_translations
		if @defer_translations != nil && @defer_translations != ''
			content_tag :script, type: 'text/javascript' do
				concat 't = {'
				concat @defer_translations.gsub(/,\z/, '').html_safe
				concat '};'
			end
		else
			''
		end
	end

	def controller_is? *options
		options.map{ |option| option.to_s }.include? controller_name
	end

	def action_is? *options
		options.map{ |option| option.to_s }.include? action_name
	end
end
