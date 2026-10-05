function audioSetSpeed(v){
  var a = document.getElementById('audio-player');
  if(a){a.playbackRate = parseFloat(v);}
}
function audioPlay(){
  var a = document.getElementById('audio-player');
  if(a){a.currentTime = 0; a.play();}
}
var _audioCountdown = null;
function audioPlayDelayed(){
  var a = document.getElementById('audio-player');
  var btn = document.getElementById('audio-play-delay');
  if(!a || !btn) return;
  if(_audioCountdown){
    clearInterval(_audioCountdown);
    _audioCountdown = null;
    btn.textContent = '▶ Play in 3s';
    return;
  }
  if(!a.paused){
    a.pause();
    a.currentTime = 0;
    return;
  }
  var n = 3;
  btn.textContent = n + '…';
  _audioCountdown = setInterval(function(){
    n--;
    if(n > 0){
      btn.textContent = n + '…';
    } else {
      clearInterval(_audioCountdown);
      _audioCountdown = null;
      btn.textContent = '▶ Play in 3s';
      audioPlay();
    }
  }, 1000);
}
