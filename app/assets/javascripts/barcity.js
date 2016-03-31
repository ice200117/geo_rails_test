/*bdqx_compare_chart.js*/

<<<<<<< HEAD
=======

>>>>>>> b90ede2214dc96a31b36e092746c86f7d13002de
var city1 = '廊坊';

$(function() 
{                         


   $('#city1').attr('value',city1);


   var citysel1=new Vcity.CitySelector({input:'city1'});  
   $('#myTab1 a:first').tab('show');//初始化显示哪个tab 
  
   $('#myTab1 a').click(function (e) { 
      e.preventDefault();//阻止a链接的跳转行为 
      $(this).tab('show');//显示当前选中的链接及关联的content
   }); 

}); 

