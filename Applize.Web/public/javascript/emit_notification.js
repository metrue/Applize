(function() {
  if (!('Notification' in window)) {
    alert('Notification not supported in this browser');
    return;
  }


  if (Notification.permissions === 'granted') {
    setTimeout( function() {
      var notification = new Notification('If you see this on your app, notification works then')
    }, 3000)
  } else if (Notification.permission !== 'denied') {
    Notification.requestPermission( function(permission) {
      if (permission === 'granted') {
        setInterval( function() {
          var notification = new Notification('If you see this on your app, notification works then')
        }, 3000)
      }
    });
  }
})()
