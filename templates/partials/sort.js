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
