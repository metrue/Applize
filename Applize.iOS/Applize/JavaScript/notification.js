(function() {
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
 
    this.Notification = Notification;
 })(this);