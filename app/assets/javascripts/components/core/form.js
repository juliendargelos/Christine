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
