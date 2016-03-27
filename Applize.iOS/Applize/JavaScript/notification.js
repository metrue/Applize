'use strict';

//

var Notification = function(title, options) {
  if (typeof title === 'undefined') {
    title = ''; 
  }   

  var body = '';
  if (typeof options === 'object') {
    if (object.body) {
      body = object.body;
    }
  }

  window.location.href = 'APPLIZE://ACTION/NOTIFICATION/DATA/' + 'title=' + title + '&' + 'body=' + body;
};

Notification.requestPermission = function(callback) {
  callback('granted');
};

Notification.permission = 'granted';

// length is readonly propery of function, 
// and it's unconfigurable, so I have no 
// idea to set it to 1, but Web Notification
// 's lenght should be 1 at begining
//
//Object.defineProperty(Notification, "length", {
//    value: 0,
//    configurable: true,
//    writable: true,
//    enumerable: true
//});

//Notification.length = 1;
