main.init('basket', [
	'Request'
]);

var basket = {
	request: new Request(null, {product_id: null}, null, true),
	add: function(id) {
		this.request.url = routes.add_to_basket;
		this.request.method = 'post';
		this.send(id);
	},
	remove: function(id) {
		this.request.url = routes.remove_from_basket;
		this.request.method = 'post';
		this.send(id);
	},
	send: function(id) {
		this.request.data.product_id = id;
		this.request.method = 'get';
		this.request.send();
	},
	fill: function(basket) {
		alert('basket filled');
	},
	update: function(basket) {
		if(basket === undefined) {
			this.request.url = routes.show_basket;
			this.request.send();
		}
		else this.fill(basket);
	},
	init: function() {
		var self = this;

		this.request.success(function(response) {
			if(response.status) self.update(response.basket)
			if(response.message) alert(response.message);
		}).error(function() {
			if(response.message) alert(t.server_error);
		});
	}
};
