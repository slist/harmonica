(function(){
  var _col=-1,_asc=true;
  window.sortTable=function(th){
    var table=th.closest('table');
    var tbody=table.tBodies[0];
    var rows=Array.from(tbody.rows);
    var col=th.cellIndex;
    if(_col===col){_asc=!_asc;}else{_col=col;_asc=!th.classList.contains('sort-desc-first');}
    rows.sort(function(a,b){
      var va=(a.cells[col]&&a.cells[col].dataset.sort!==undefined)?a.cells[col].dataset.sort:a.cells[col].textContent.trim();
      var vb=(b.cells[col]&&b.cells[col].dataset.sort!==undefined)?b.cells[col].dataset.sort:b.cells[col].textContent.trim();
      var na=parseFloat(va),nb=parseFloat(vb);
      if(!isNaN(na)&&!isNaN(nb)){return _asc?na-nb:nb-na;}
      return _asc?va.localeCompare(vb,'fr'):vb.localeCompare(va,'fr');
    });
    rows.forEach(function(r){tbody.appendChild(r);});
    table.querySelectorAll('thead th').forEach(function(t,i){
      t.classList.remove('sort-asc','sort-desc');
      if(i===col){t.classList.add(_asc?'sort-asc':'sort-desc');}
    });
  };
})();

/* Tooltips au toucher : les attributs title ne s'affichent pas sans survol (Android/iOS). */
(function(){
  var tip=null,timer=null;
  function hide(){if(tip){tip.remove();tip=null;}clearTimeout(timer);}
  document.addEventListener('click',function(e){
    var el=e.target.closest&&e.target.closest('td[title],span[title]');
    if(!el||!window.matchMedia('(hover: none)').matches){hide();return;}
    var text=el.getAttribute('title');
    if(!text){return;}
    hide();
    tip=document.createElement('div');
    tip.textContent=text.replace(/ \| /g,'\n');
    tip.style.cssText='position:absolute;z-index:1000;max-width:80vw;white-space:pre-line;'+
      'padding:.5em .8em;border-radius:6px;font-size:.9rem;line-height:1.4;pointer-events:none;'+
      'background:var(--ink);color:var(--bg);box-shadow:0 2px 8px rgba(0,0,0,.35)';
    document.body.appendChild(tip);
    var r=el.getBoundingClientRect();
    var left=Math.max(8,Math.min(r.left+window.scrollX,window.scrollX+document.documentElement.clientWidth-tip.offsetWidth-8));
    tip.style.left=left+'px';
    tip.style.top=(r.bottom+window.scrollY+6)+'px';
    timer=setTimeout(hide,4000);
  });
  window.addEventListener('scroll',hide,{passive:true});
})();
