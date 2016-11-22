main.init('flash', [
	'eventsManager'
]);

var flash = {
	get element() {
		return document.querySelector('.flash');
	},
	transition: 200,
	duration: 4000,
	interval: null,
	construct: function(message, type) {
		var div = document.createElement('div');
		div.className = 'flash '+type;

		var p = document.createElement('p');
		p.className = 'wrapper';

		p.appendChild(document.createTextNode(message));

		div.appendChild(p);

		return div;
	},
	append: function(element) {
		var firstChild = document.body.firstChild;
		if(firstChild) document.body.insertBefore(element, firstChild);
		else document.body.appendChild(element);
		this.init();
	},
	set: function(message, type) {
		if(type === undefined) type = 'notice';

		var element = this.construct(message, type);
		if(this.element) {
			var self = this;
			clearInterval(this.interval);
			this.hide();
			setTimeout(function() {
				self.append(element);
			}, this.transition+1);
		}
		else this.append(element);

	},
	remove: function() {
		if(this.element) this.element.parentNode.removeChild(this.element);
	},
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
			self.remove();
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
