main.init('Color');

var Color = function(r, g, b, a) {
	var self = this;

	var value = {
		r: 0,
		g: 0,
		b: 0,
		a: 1
	};

	var set = {
		rgb: function(string) {
			var m = string.match(/^\s*rgb\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*\)\s*$/);
			if(m !== null) {
				self.r= m [1];
				self.g= m [2];
				self.b= m [3];
				self.a = 1;
				return true;
			}
			else return false;
		},
		rgba: function(string) {
			var m = string.match(/^\s*rgba\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*([\d\.]+)\s*\)\s*$/);
			if(m !== null) {
				self.r = m[1];
				self.g = m[2];
				self.b = m[3];
				self.a = m[4];
				return true;
			}
			else return false;
		},
		hex: function(string) {
			var m = string.match(/^\s*#([0-9a-fA-F]{2})([0-9a-fA-F]{2})([0-9a-fA-F]{2})\s*$/);
			if(m !== null) {
				self.r = parseInt(m[1], 16);
				self.g = parseInt(m[2], 16);
				self.b = parseInt(m[3], 16);
				self.a = 1;
				return true;
			}
			else {
				var m = string.match(/^\s*#([0-9a-fA-F])([0-9a-fA-F])([0-9a-fA-F])\s*$/);
				if(m !== null) {
					self.r = parseInt(m[1]+m[1], 16);
					self.g = parseInt(m[2]+m[2], 16);
					self.b = parseInt(m[3]+m[3], 16);
					self.a = 1;
					return true;
				}
				else return false;
			}

		},
		string: function(string) {
			for(var f in this) {
				if(f != 'string') {
					if(this[f](string)) return true;
				}
			}
			return false;
		}
	};

	Object.defineProperties(this,{
		r: {
			get: function() {return value.r;},
			set: function(v) {v = parseInt(v);value.r = v>255 ? 255 : (v<0 ? 0 : v);}
		},
		red: {
			get: function() {return value.r;},
			set: function(v) {v = parseInt(v);value.r = v>255 ? 255 : (v<0 ? 0 : v);}
		},
		g: {
			get: function() {return value.g;},
			set: function(v) {v = parseInt(v);value.g = v>255 ? 255 : (v<0 ? 0 : v);}
		},
		green: {
			get: function() {return value.g;},
			set: function(v) {v = parseInt(v);value.g = v>255 ? 255 : (v<0 ? 0 : v);}
		},
		b: {
			get: function() {return value.b;},
			set: function(v) {v = parseInt(v);value.b = v>255 ? 255 : (v<0 ? 0 : v);}
		},
		blue: {
			get: function() {return value.b;},
			set: function(v) {v = parseInt(v);value.b = v>255 ? 255 : (v<0 ? 0 : v);}
		},
		a: {
			get: function() {return value.a;},
			set: function(v) {v = parseFloat(v);value.a = v>1 ? 1 : (v<0 ? 0 : v);}
		},
		alpha: {
			get: function() {return value.a;},
			set: function(v) {v = parseFloat(v);value.a = v>1 ? 1 : (v<0 ? 0 : v);}
		},
		rgb: {
			get: function() {return 'rgb('+this.r+','+this.g+','+this.b+')';},
			set: function(v) {set.rgb(v);}
		},
		rgba: {
			get: function() {return 'rgba('+this.r+','+this.g+','+this.b+','+this.a+')';},
			set: function(v) {set.rgba(v);}
		},
		hex: {
			get: function() {
				var r = this.r.toString(16);
				var g = this.g.toString(16);
				var b = this.b.toString(16);
				return '#'+(r.length<2 ? '0'+r : r)+(g.length<2 ? '0'+g : g)+(b.length<2 ? '0'+b : b);
			},
			set: function(v) {set.hex(v);}
		},
		string: {
			get: function() {return this.rgba;},
			set: function(v) {set.string(v);}
		}
	});

	if(typeof r == 'string' && g === undefined) this.string = r;
	else if(typeof r == 'object' && r !== null && g === undefined) {
		var c = r;
		if(typeof c.r == 'number') this.r = c.r;
		if(typeof c.g == 'number') this.g = c.g;
		if(typeof c.b == 'number') this.b = c.b;
		if(typeof c.a == 'number') this.a = c.a;
	}
	else {
		if(typeof r == 'number') this.r = r;
		if(typeof g == 'number') this.g = g;
		if(typeof b == 'number') this.b = b;
		if(typeof a == 'number') this.a = a;
	}
};

Color.average = function(from, to, ratio) {
	if(ratio === undefined) ratio = 0.5;
	else if(ratio>1) ratio = 1;
	else if(ratio<0) ratio = 0;
	var from = (from instanceof Color ? from : new Color(from));
	var to = (to instanceof Color ? to : new Color(to));
	var delta = {r: to.r-from.r, g: to.g-from.g, b: to.b-from.b, a: to.a-from.a};
	return new Color(from.r+(delta.r*ratio), from.g+(delta.g*ratio), from.b+(delta.b*ratio), from.a+(delta.a*ratio));
};

Color.path = function(path, ratio) {
	if(ratio === undefined) ratio = 0;
	else if(ratio>1) ratio = 1;
	else if(ratio<0) ratio = 0;

	var offset = Math.floor(ratio*path.length);
	if(offset>path.length-2) offset = path.length-2;

	ratio = ratio-(offset)/path.length;

	return Color.average(path[offset], path[offset+1], ratio);
};
