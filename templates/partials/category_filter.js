(function(){
  var table=document.getElementById('data-table');
  var filter=document.getElementById('category-filter');
  if(!table||!filter){return;}

  var categories=Array.from(new Set(Array.from(table.querySelectorAll('tbody td.category'))
    .map(function(cell){return cell.textContent.trim();}).filter(Boolean)))
    .sort(function(a,b){return a.localeCompare(b,'fr');});

  categories.forEach(function(category){
    var option=document.createElement('option');
    option.value=category;
    option.textContent=category;
    filter.appendChild(option);
  });

  filter.addEventListener('change',function(){
    Array.from(table.tBodies[0].rows).forEach(function(row){
      var cell=row.querySelector('td.category');
      row.hidden=filter.value!==''&&(!cell||cell.textContent.trim()!==filter.value);
    });
  });
})();
