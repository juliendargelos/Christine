main.init('header', [
	'eventsManager'
]);

var header = {
	element: document.querySelector('header'),
	nav: {
		element: document.querySelector('header nav'),
		toggleElement: document.querySelector('header .toggle-nav'),
		items: {},
		toggleItem: function(event) {
			if(this.getAttribute('data-open') === null) this.setAttribute('data-open', '');
			else this.removeAttribute('data-open');

			event.preventDefault();
		},
		toggle: function() {
			if(this.element.getAttribute('data-open') === null) {
				this.element.removeAttribute('data-close');
				this.element.setAttribute('data-open', '');
			}
			else {
				this.element.setAttribute('data-close', '');
				this.element.removeAttribute('data-open');
			}
		},
		init: function() {
			var self = this;

			var items = header.element.querySelectorAll('nav > a');
			for(var i = 0; i < items.length; i++) this.items[items[i].className] = items[i];

			var togglableItems =  this.element.querySelectorAll('[data-toggle]');
			for(var i = 0; i < togglableItems.length; i++) togglableItems[i].on('click', this.toggleItem);

			if(this.items.newSession) {
				this.items.newSession.on('click', function() {
					var self = this;
					this.nextSibling.querySelector('input:not([type="hidden"])').focus();
				});
			}

			this.toggleElement.on('click', function() {
				self.toggle();
			});
		}
	},
	init: function() {
		this.nav.init();
	}
};
