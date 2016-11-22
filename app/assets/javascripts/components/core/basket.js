main.init('basket', [
	'Request'
]);

var basket = {
	element: document.querySelector('#basket'),
	callback: null,
	requests: {
		add: null,
		remove: null,
		show: null,
		clear: null
	},
	construct: {
		basket: function(basket) {
			var elements = [];
			var purchases = basket.purchases;
			if(purchases.length > 0) {
				for(var i = 0; i < purchases.length; i++) elements.push(this.purchase(purchases[i]));
				elements.push(this.actions(basket));
			}
			else elements.push(this.empty());

			return elements;
		},
		purchase: function(purchase) {
			var li = document.createElement('li');

			var a = document.createElement('a');
			a.href = routes.product(purchase.product.id);

			var image = document.createElement('div');
			image.className = 'image';

			var img = document.createElement('img');
			img.src = purchase.product.attachments[0].file.url;

			var name = document.createElement('span');
			name.className = 'name';
			name.appendChild(document.createTextNode(purchase.product.name));

			var quantity = document.createElement('span');
			quantity.className = 'quantity';
			quantity.appendChild(document.createTextNode(purchase.quantity));

			var price = document.createElement('span');
			price.className = 'price';
			price.appendChild(document.createTextNode(purchase.total_price+'€'));

			var remove = document.createElement('span');
			remove.className = 'remove';
			remove.appendChild(document.createTextNode(t.basket_remove));
			remove.on('click', function(event) {
				basket.remove(purchase.product.id);
				event.stopPropagation();
				event.preventDefault();
			});

			image.appendChild(img);

			a.appendChild(image);
			a.appendChild(name);
			a.appendChild(quantity);
			a.appendChild(price);
			a.appendChild(remove);

			li.appendChild(a);

			return li;
		},
		empty: function() {
			var li = document.createElement('li');
			li.className = 'empty';

			li.appendChild(document.createTextNode(t.basket_is_empty));

			return li;
		},
		actions: function(basket) {
			var li = document.createElement('li');
			li.className = 'actions';

			var clear = document.createElement('span');
			clear.className = 'button red clear';
			clear.on('click', function() {
				window.basket.clear();
			});

			var order = document.createElement('span');
			order.className = 'button brand order';

			var total = document.createElement('span');
			total.className = 'total';

			clear.appendChild(document.createTextNode(t.clear_basket));

			total.appendChild(document.createTextNode(basket.total_price+'€'));

			order.appendChild(total);
			order.appendChild(document.createTextNode(t.order));

			li.appendChild(clear);
			li.appendChild(order);

			return li;
		}
	},
	add: function(id) {
		this.requests.add.send({product_id: id});
	},
	remove: function(id) {
		this.requests.remove.send({product_id: id});
	},
	update: function(basket) {
		if(basket === undefined) this.requests.show.send();
		else this.fill(basket);
	},
	clear: function() {
		this.requests.clear.send();
	},
	fill: function(basket) {
		elements = this.construct.basket(basket);
		this.element.innerHTML = '';
		for(var i = 0; i < elements.length; i++) this.element.appendChild(elements[i]);
	},
	success: function(response) {
		if(response.status) this.update(response.basket)
		if(response.message) flash.set(response.message, response.status ? 'success' : 'error');
	},
	error: function() {
		flash.set(t.server_error, 'error');
	},
	init: function() {
		if(this.element) {
			var self = this;

			this.requests.add = new Request(routes.add_to_basket, null, 'post', true);
			this.requests.add.success(function(response) {
				self.success(response);
			}).error(this.error);

			this.requests.clear = new Request(routes.clear_basket, null, 'get', true);
			this.requests.clear.success(function(response) {
				self.success(response);
			}).error(this.error);

			this.requests.remove = new Request(routes.remove_from_basket, null, 'post', true);
			this.requests.remove.success(function(response) {
				self.success(response);
			}).error(this.error);

			this.requests.show = new Request(routes.basket, null, 'get', true);
			this.requests.show.success(function(response) {
				self.success(response);
			}).error(this.error);

			this.update();
		}
	}
};
