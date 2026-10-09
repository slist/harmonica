function audioSetSpeed(v){
  var a = document.getElementById('audio-player');
  if(a){a.playbackRate = parseFloat(v);}
}
function audioPlay(){
  var a = document.getElementById('audio-player');
  if(a){a.currentTime = 0; a.play();}
}
function audioPause(){
  var a = document.getElementById('audio-player');
  if(!a) return;
  if(a.paused){a.play();} else {a.pause();}
}
var _audioStopping = false;
function audioStop(){
  var a = document.getElementById('audio-player');
  if(a){_audioStopping = true; a.pause(); a.currentTime = 0;}
}
function audioSetPauseBlink(active){
  var btn = document.getElementById('audio-pause-btn');
  if(btn){btn.classList.toggle('blinking', active);}
}
function audioShowIdleButtons(){
  var idle = document.getElementById('audio-idle-buttons');
  var playing = document.getElementById('audio-playing-buttons');
  if(idle){idle.hidden = false;}
  if(playing){playing.hidden = true;}
}
function audioShowPlayingButtons(){
  var idle = document.getElementById('audio-idle-buttons');
  var playing = document.getElementById('audio-playing-buttons');
  if(idle){idle.hidden = true;}
  if(playing){playing.hidden = false;}
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
var _audioRestartCountdown = null;
var _audioRestartPending = false;
function audioRestartDelayed(){
  var btn = document.getElementById('audio-restart-delay');
  if(!btn) return;
  if(_audioRestartCountdown){
    clearInterval(_audioRestartCountdown);
    _audioRestartCountdown = null;
    _audioRestartPending = false;
    btn.textContent = '↻ Restart in 3s';
    audioShowIdleButtons();
    return;
  }
  audioStop();
  _audioRestartPending = true;
  var n = 3;
  btn.textContent = n + '…';
  _audioRestartCountdown = setInterval(function(){
    n--;
    if(n > 0){
      btn.textContent = n + '…';
    } else {
      clearInterval(_audioRestartCountdown);
      _audioRestartCountdown = null;
      _audioRestartPending = false;
      btn.textContent = '↻ Restart in 3s';
      audioPlay();
    }
  }, 1000);
}
(function(){
  var a = document.getElementById('audio-player');
  if(!a) return;
  a.addEventListener('play', function(){
    audioSetPauseBlink(false);
    audioShowPlayingButtons();
  });
  a.addEventListener('pause', function(){
    if(_audioRestartPending){_audioStopping = false; return;}
    if(_audioStopping){
      _audioStopping = false;
      audioSetPauseBlink(false);
      audioShowIdleButtons();
      return;
    }
    audioSetPauseBlink(true);
  });
  a.addEventListener('ended', function(){
    audioSetPauseBlink(false);
    audioShowIdleButtons();
  });
})();
