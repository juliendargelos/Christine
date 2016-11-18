# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

module AssetsPrecompiler
	PATH = __dir__+'/../../app/assets'
	VENDORS = __dir__+'/../../vendor/assets'

	@@types = {
		stylesheets: {
			path: PATH+'/stylesheets',
			from: :sass,
			to: :css
		},
		javascripts: {
			path: PATH+'/javascripts',
			from: :js,
			to: :js
		}
	}

	@@precompiled = {
		stylesheets: {},
		javascripts: {}
	}

	@@cache = ActiveSupport::Cache::MemoryStore.new

	def self.path *parts
		path = PATH
		parts.flatten.each do |part|
			path += '/'+part.to_s.gsub(/\A\//, '').gsub(/\/\z/, '')
		end

		path
	end

	def self.precompile quiet = false, except = [:destroy]
		self.init

		except = [] unless except.is_a? Array

		self.controllers_actions do |controller, action, combination|
			unless except.include? :"#{action}"
				@@types.each do |type, params|
					path = params[:path]+"/#{combination}.#{params[:from]}"

					if File.file?(path) || File.file?(path+'.erb')
						file = combination
					else
						file = controller
					end

					self.add controller, action, file, type
				end
			end
		end

		puts '------------------------'
		{stylesheets: [:css, :sass], javascripts: [:js, :coffee]}.each do |type, exts|
			exts.each do |ext|
				path = VENDORS + "/#{type}"

				files = (Dir[path+"/*.#{ext}"] + Dir[path+"/**/*.#{ext}"]).map do |file|
					file = file.gsub /\A.*?\/([^\/]+)\z/, '\1'
					file = file.gsub /\.[^\.]+\z/, ".#{@@types[type][:to]}"
					file
				end
				Rails.application.config.assets.precompile += files
			end
		end
		puts '------------------------'

		self.print_precompiled unless quiet == :quiet
	end

	def self.stylesheet_for controller, action
		self.file_for :stylesheets, controller, action
	end

	def self.javascript_for controller, action
		self.file_for :javascripts, controller, action
	end

	private
		def self.file_for type, controller, action
			precompiled = @@precompiled

			if precompiled[type].key? controller
				actions = precompiled[type][controller]
				if actions.key? action
					return actions[action]
				end
			end

			nil
		end

		def self.controllers_actions &block
			ApplicationController.descendants.each do |controller|
				actions = controller.action_methods
				controller = controller.to_s
				controller = controller[0, controller.length - 'controller'.length].downcase

				actions.each do |action|
					block.call controller, action, "#{controller}-#{action}"
				end
			end
		end

		def self.add controller, action, file, type
			unless @@precompiled[type][controller].is_a? Hash
				@@precompiled[type][controller] = {}
			end

			@@precompiled[type][controller][action] = file

			Rails.application.config.assets.precompile << "#{file}.#{@@types[type][:to]}"
		end

		def self.init
			Rails.application.eager_load!
		end

		def self.print_precompiled
			puts ''
			@@precompiled.each do |type, controllers|
				type = type.to_s.upcase
				puts type
				puts Array.new(type.length, '-').join
				controllers.each do |controller, actions|
					puts controller
					actions.each do |action, precompiled|
						puts "  #{action}: #{precompiled}"
					end
				end
				puts ''
			end
		end
end

AssetsPrecompiler.precompile
