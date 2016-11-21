main.init('cover', [
	'eventsManager',
	'scroll',
	'Color',
	'header'
]);

var cover = {
	element: document.querySelector('.cover'),
	was: -1,
	get height() {
		return this.element.offsetHeight;
	},
	get ratio() {
		var ratio = scroll.top/(this.height - header.height);
		return ratio > 1 ? 1 : (ratio < 0 ? 0 : ratio);
	},
	overlay: {
		element: document.querySelector('.cover .overlay'),
		children: document.querySelectorAll('.cover .overlay > *'),
		color: new Color('#65ad74'),
		speed: 3,
		set opacity(v) {
			v = 1 - v*this.speed;
			for(var i = 0; i < this.children.length; i++) this.children[i].style.opacity = v;
		},
		set background(v) {
			this.element.style.background = v;
		},
		get alpha() {
			return 0.8;
		},
		set alpha(v) {
			this.color.alpha = v*(1 - this.alpha) + this.alpha;

			this.opacity = v;
			this.background = this.color.rgba;
		}
	},
	update: function() {
		var ratio = this.ratio;
		if(ratio != this.was) {
			if(ratio == 1) header.background = this.overlay.color.hex;
			else if(this.was == 1) header.background = '';

			this.was = ratio;
			this.overlay.alpha = ratio;
		}
	},
	init: function() {
		if(this.element) {
			var self = this;

			this.update();
			on('scroll', function() {
				self.update();
			});
		}
	}
};
