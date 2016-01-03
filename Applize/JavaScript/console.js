/*
   console.js
   Applize

   Created by huangmh on 1/3/16.
   Copyright © 2016 minghe. All rights reserved.
 */
(function(window) {
	var Console = {
	  log: function() {
	    var message = '';
	    for(var i = 0; i < arguments.length; i++) {
	      message += arguments[i] + ' ';
			}
	    window.location.href="APPLIZE://ACTION/CONSOLE/LOG/DATA/" + message;
		},
	  error: function() {
	    var message = '';
	    for(var i = 0; i < arguments.length; i++) {
	      message += arguments[i] + ' ';
			}
	    window.location.href="APPLIZE://ACTION/CONSOLE/ERROR/DATA/" + message;
		},

	  warn: function() {
	    var message = '';
	    for(var i = 0; i < arguments.length; i++) {
	      message += arguments[i] + ' ';
			}
	    window.location.href="APPLIZE://ACTION/CONSOLE/WARN/DATA/" + message;
		},
	  info: function() {
	    var message = '';
	    for(var i = 0; i < arguments.length; i++) {
	      message += arguments[i] + ' ';
			}
	    window.location.href="APPLIZE://ACTION/CONSOLE/INFO/DATA/" + message;
		},
	  debug: function() {
	    var message = '';
	    for(var i = 0; i < arguments.length; i++) {
	      message += arguments[i] + ' ';
			}
	    window.location.href="APPLIZE://ACTION/CONSOLE/DEBUG/DATA/" + message;
		}
	};

	console = Console;
})(this);