(function(){
  var storageKey='harmonica-theme';
  var theme='dark';
  try{
    var savedTheme=localStorage.getItem(storageKey);
    if(savedTheme==='light'||savedTheme==='dark') theme=savedTheme;
  }catch(error){
    console.error('Impossible de lire le thème enregistré.',error);
  }
  document.documentElement.dataset.theme=theme;

  document.addEventListener('DOMContentLoaded',function(){
    var selector=document.getElementById('theme-select');
    if(!selector) return;
    selector.value=theme;
    selector.addEventListener('change',function(){
      theme=selector.value==='light'?'light':'dark';
      document.documentElement.dataset.theme=theme;
      try{
        localStorage.setItem(storageKey,theme);
      }catch(error){
        console.error('Impossible d’enregistrer le thème choisi.',error);
      }
    });
  });
})();
