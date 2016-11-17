//= require_self
//= require_directory .

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
