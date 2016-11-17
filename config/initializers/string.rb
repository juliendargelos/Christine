class String
    def ucfirst
        str = self.clone
        str[0] = str[0, 1].upcase
        str
    end

    def to_slug options

        options[:delimiter] = options[:delimiter] == nil ? '-' : options[:delimiter].to_s[0]
        options[:lowercase] = options[:lowercase] != false

        str = self.clone
		str = str.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n, '')
		str = str.downcase if options[:lowercase]
		str = str.gsub(/[^A-Za-z0-9]/, options[:delimiter])
		str = str.gsub(/#{options[:delimiter] + options[:delimiter]}+/, options[:delimiter])
		str = str.gsub(/\A#{options[:delimiter]}/, '').gsub(/#{options[:delimiter]}\z/, '')
    end
end
