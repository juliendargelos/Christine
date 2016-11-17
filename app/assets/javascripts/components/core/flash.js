main.init('flash', [
	'eventsManager'
]);

var flash = {
	element: document.querySelector('.flash'),
	transition: 200,
	duration: 4000,
	interval: null,
	get height() {
		return this.element.offsetHeight;
	},
	set top(v) {
		this.element.style.marginTop = v+'px';
	},
	set visible(v) {
		if(v) this.element.setAttribute('data-visible', true);
		else this.element.removeAttribute('data-visible');
	},
	show: function() {
		var self = this;

		this.top = -this.height;
		setTimeout(function() {
			self.visible = true;

			setTimeout(function() {
				self.top = 0;
			}, self.transition);
		}, 1)
	},
	hide: function() {
		var self = this;

		this.top = -this.height;

		setTimeout(function() {
			self.visible = false;
		}, this.transition);
	},
	init: function() {
		var self = this;

		if(this.element) {
			this.show();

			this.interval = setTimeout(function() {
				self.hide();
			}, this.duration+this.transition);

			this.element.on('click', function() {
				clearInterval(self.interval);
				self.hide();
			});
		}
	}
};
