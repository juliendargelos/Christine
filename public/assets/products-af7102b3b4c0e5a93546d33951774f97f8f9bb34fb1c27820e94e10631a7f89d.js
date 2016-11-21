


var main = {
	quiet: false,
	stack: {},
	initialized: [],
	require: function(component) {
		if(this.initialized.indexOf(component) > -1) return true;

		var required = this.stack[component];

		for(var i = 0; i < required.length; i++) {
			var r = required[i];
			if(this.stack[r] !== undefined) {
				if(!this.require(r)) return false;
			}
			else {
				if(!this.quiet) console.error('Unable to load component "'+r+'" required by "'+component+'"');
				return false;
			}
		}

		window[component].init();
		this.initialized.push(component);

		return true;
	},
	exec: function(component, required) {
		if(component !== undefined) this.init(component, required);
		this.init();
	},
	init: function(component, required) {
		if(component !== undefined) this.stack[component] = required === undefined ? [] : required;
		else {
			for(var component in this.stack) this.require(component);
		}
	}
};
main.init('eventsManager');

var eventsManager = {
	on: function(event, callback, element, useCapture) {
		element.addEventListener(event, callback, useCapture === undefined ? false : useCapture);
	},
	no: function(event, callback, element) {
		element.removeEventListener(event, callback);
	},
	apply: function(element) {
		element.on = function(event, callback) {window.eventsManager.on(event, callback, this);};
		element.no = function(event, callback) {window.eventsManager.no(event, callback, this);};
	},
	init: function() {
		this.apply(window);
		this.apply(Node.prototype);
	}
};
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
main.init('form', [
	'eventsManager'
]);

var form = {
	elements: document.querySelectorAll('form'),
	click: function(firstInput) {
		return function() {
			firstInput.focus();
		};
	},
	focus: function(field) {
		return function() {
			field.setAttribute('data-focus', '');
		};
	},
	blur: function(field) {
		return function() {
			field.removeAttribute('data-focus');
		};
	},
	stopPropagation: function(event) {
		event.stopPropagation();
	},
	init: function(element) {
		if(element instanceof Node) {
			var fields = element.querySelectorAll('.field');
			for(var i = 0; i < fields.length; i++) {
				var field = fields[i];
				var inputs = field.querySelectorAll('input, textarea, select');

				if(inputs.length > 0) {
					field.on('click', this.click(inputs[0]))

					for(var j = 0; j < inputs.length; j++) {
						var input = inputs[j];
						input.on('focus', this.focus(field));
						input.on('blur', this.blur(field));
						input.on('click', this.stopPropagation);
					}
				}
			}
		}
		else {
			for(var i = 0; i < this.elements.length; i++) this.init(this.elements[i]);
		}
	}
};
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

var products = {
	carousel: {
		element: document.querySelector('.carousel'),
		flickity: null,
		init: function() {
			if(this.element) {
				this.flickity = new Flickity(this.element);
			}
		}
	},
	form: {
		element: document.querySelector('#new_product, .edit_product'),
		attachments: {
			element: document.querySelector('#new_product .attachments-fields, .edit_product .attachments-fields'),
			get fields() {
				return this.element.querySelectorAll('.field');
			},
			get field() {
				var field = document.createElement('div');
				field.className = 'field';

				var label = document.createElement('label');
				label.appendChild(document.createTextNode(t.file));

				var input = document.createElement('input');
				input.type = 'file';
				input.empty = true;

				var remove = document.createElement('span');
				remove.className = 'remove';
				remove.appendChild(document.createTextNode(t.remove));

				var add = document.createElement('span');
				add.className = 'add';
				add.appendChild(document.createTextNode(t.add));

				field.appendChild(label);
				field.appendChild(input);
				field.appendChild(remove);
				field.appendChild(add);

				this.events(field);

				return field;
			},
			events: function(field) {
				var self = this;

				var input = field.querySelector('input');
				var remove = field.querySelector('.remove');
				var add = field.querySelector('.add');

				input.on('change', function() {
					if(input.empty) {
						input.empty = false;

						var fields = self.fields;
						if(fields[fields.length - 1] == field) self.add();
					}
				});

				remove.on('click', function() {
					if(field.parentNode) {
						var destroy = field.querySelector('input[type="checkbox"]');

						if(destroy) {
							field.className = 'field-destroy';
							destroy.setAttribute('checked', true);
						}
						else {
							field.parentNode.removeChild(field);
							self.update();
						}
					}
				});

				add.on('click', function() {
					self.add();
				});
			},
			set: function(field, n) {
				var label = field.querySelector('label');
				var input = field.querySelector('input');

				var id = 'product_attachment_attributes_'+n+'_file';
				var name = 'product[attachments_attributes]['+n+'][file]';

				label.setAttribute('for', id);
				input.setAttribute('name', name);
				input.setAttribute('id', id);
			},
			add: function() {
				this.element.appendChild(this.field);
				this.update();
			},
			update: function() {
				var fields = this.fields;
				for(var i = 0; i < fields.length; i++) this.set(fields[i], i);
			},
			init: function() {
				var fields = this.fields;
				for(var i = 0; i < fields.length; i++) this.events(fields[i]);
			}
		},
		init: function() {
			if(this.element) {
				this.attachments.init();
			}
		}
	},
	init: function() {
		this.carousel.init();
		this.form.init();
	}
};

main.exec('products', [
	'eventsManager'
]);
