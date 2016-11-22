# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def seed_file *parts
	parts = parts.flatten
	if parts.length > 0
		path = __dir__+'/seed_files/'+parts.map{ |part| part.to_s }.join('/').gsub(/\/\/+/, '/')
		File.new(path)
	end
end

def create_product name, price, gender = :masculine
	feminine = gender == :feminine
	the = 'l'+(feminine ? 'a' : 'e')
	u_the = 'L'+(feminine ? 'a' : 'e')
	it = feminine ? 'elle' : 'il'
	fruity = 'fruité'+(feminine ? 'e' : '')
	smooth = 'dou'+(feminine ? 'ce' : 'x')

	Product.new({
		name: name.to_s.humanize,
		price: price,
		description: "#{u_the} #{name} Christine fait le bonheur de vos papilles depuis 2016. Un mélange audacieux entre simplicité et élégance, #{it} fait ravage auprès de tous. À la fois #{fruity} et #{smooth}, c’est #{the} #{name} d’excellence qu’il vous faut pour passer le plus merveilleux des moments. À déguster en bonne compagnie.",
		baseline: "Une boisson pour ceux qui savent apprécier #{the} #{name}",
		attachments: [
			Attachment.new({ file: seed_file("#{name}_front.png")}),
			Attachment.new({ file: seed_file("#{name}_back.png")})
		]
	})
end

def create_products *all
	products = []
	all.each do |params|
		params[:gender] = :masculine unless params.key? :gender
		products << create_product(params[:name], params[:price], params[:gender])
	end

	products
end

create_products(
	{
		name: :rhum,
		price: 2500
	},
	{
		name: :vodka,
		price: 2900,
		gender: :feminine
	},
	{
		name: :whisky,
		price: 3200
	}
).each do |product|
	puts "[#{product.save ? 'SAVED' : 'FAILED'}] #{product.name} (#{product.plain_price}#{Product.currency[:symbol]})"
end
