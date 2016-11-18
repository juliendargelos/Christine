//= require ./components/core/main

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
