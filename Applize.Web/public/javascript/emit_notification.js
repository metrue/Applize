(function() {
  if (!('Notification' in window)) {
    console.warn('Notification not supported in this browser')
    return
  }

  if (Notification.permissions === 'granted') {
    setInterval( function() {
      var notification = new Notification('Hi, I will keep saying this') 
    }, 1000) 
  } else if (Notification.permission !== 'denied') {
    Notification.requestPermission( function(permission) {
      if (permission === 'granted') {
        setInterval( function() {
          var notification = new Notification('Hi, I will keep saying this');
        }, 1000)
      }
    });
  }
})()
