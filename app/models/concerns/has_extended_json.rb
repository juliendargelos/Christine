module HasExtendedJson
    extend ActiveSupport::Concern

    included do
		alias_method :base_as_json, :as_json

		private
            def json_options *defaults, options
                base_options = { only: options[:only], except: options[:except] }

                extended_options = {}

                defaults.each do |default|
                    extended_options[default] = {}
                end

                options.except(:only, :except).each do |key, value|
                    selectors = key.to_s.split '.'
                    if selectors.length > 1
                        extended_options[:"#{selectors.first}"] = {}
                        selected = extended_options[:"#{selectors.first}"]
                        for i in 1..selectors.length-2
                            selector = :"#{selectors[i]}"
                            selected[selector] = {}
                            selected = selected[selector]
                        end
                        selected[:"#{selectors.last}"] = value
                    else
                        extended_options[key] = value
                    end
                end

                {
                    base: base_options,
                    extended: extended_options
                }
            end
    end
end
