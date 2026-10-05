<script src="https://www.youtube.com/iframe_api"></script>
<script>
var ytPlayer;
function onYouTubeIframeAPIReady(){
  ytPlayer = new YT.Player('yt-player', {
    events: {onError: ytOnError}
  });
}
function ytOnError(){
  // La vidéo n'a pas pu être lue dans l'iframe (intégration désactivée par
  // son propriétaire, vidéo privée/supprimée…) : on retombe sur un lien direct.
  var block = document.getElementById('yt-block');
  if(block){
    block.innerHTML =
      "<a href='https://www.youtube.com/watch?v={{ video_id }}' target='_blank' rel='noopener'>📺 Voir la vidéo sur YouTube</a>";
  }
}
function ytPlay(){
  if(ytPlayer && ytPlayer.seekTo){ytPlayer.seekTo(0, true);ytPlayer.playVideo();}
}
var _ytCountdown = null;
function ytPlayDelayed(){
  var btn = document.getElementById('yt-play-delay');
  if(!btn) return;
  if(_ytCountdown){
    clearInterval(_ytCountdown);
    _ytCountdown = null;
    btn.textContent = '▶ Play in 3s';
    return;
  }
  if(ytPlayer && ytPlayer.getPlayerState && ytPlayer.getPlayerState() === YT.PlayerState.PLAYING){
    ytPlayer.pauseVideo();
    return;
  }
  var n = 3;
  btn.textContent = n + '…';
  _ytCountdown = setInterval(function(){
    n--;
    if(n > 0){
      btn.textContent = n + '…';
    } else {
      clearInterval(_ytCountdown);
      _ytCountdown = null;
      btn.textContent = '▶ Play in 3s';
      ytPlay();
    }
  }, 1000);
}
function ytSetSpeed(v){
  if(ytPlayer && ytPlayer.setPlaybackRate){ytPlayer.setPlaybackRate(parseFloat(v));}
}
function ytShow(){
  document.getElementById('yt-toggle').hidden = true;
  document.getElementById('yt-block').hidden = false;
  var media = document.getElementById('player-bar-media');
  if(media){media.hidden = true;}
  var audio = document.getElementById('audio-player');
  if(audio){audio.pause();}
}
function ytHide(){
  if(_ytCountdown){
    clearInterval(_ytCountdown);
    _ytCountdown = null;
    var delayBtn = document.getElementById('yt-play-delay');
    if(delayBtn){delayBtn.textContent = '▶ Play in 3s';}
  }
  document.getElementById('yt-toggle').hidden = false;
  document.getElementById('yt-block').hidden = true;
  var media = document.getElementById('player-bar-media');
  if(media){media.hidden = false;}
  if(ytPlayer && ytPlayer.pauseVideo){ytPlayer.pauseVideo();}
}
</script>
