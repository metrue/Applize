var audios = document.getElementsByTag('audio');
for (var i = 0; i < audios.length; i++) {
  audios[i].addEventListener('volumechange', function() {
    var fakeUrl = 'Applize://action/turnvolume/' + audios[i].volume;     
    document.location.href = fakeUrl;
  });
}
