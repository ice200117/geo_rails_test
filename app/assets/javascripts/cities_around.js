	/*周边城市*/
	
	$.get("/qinhuangdao/cities_around_fun.json",function(result){
	var j=0;
	var info=result	
	console.info(info);
	$("#table_around").append("<tr><th class='top11-title' height='10%' style='text-align:left;padding-left:10px;padding-top:10px;color: black;'>周边城市</th></tr>");
		var $tr=$("<tr style=''></tr>");
		for(var i=0;i<info.length;i++){
		$tr.append("<td class='td_around'>"+info[i]['cityname']+"&nbsp;&nbsp;<span class='' style='background:"+getColorByAQI(info[i]['aqi'])+";padding-left:8px;padding-right:8px;line-height:12px;font-size:16px'>"+info[i]['aqi']+"</span><div class='div_a_info'>"+
	"<p class='p_around'>"+
	"AQI:"+info[i]['aqi']+"<span style='background:"+getColorByAQI(info[i]['aqi'])+";color:black;padding:0px 3px;margin-left:20px'>"+info[i]['quality']+"</span>"+"</p>"+
	"<p class='p_around'>"+info[i]['temp']+"℃&nbsp;&nbsp;"+info[i]['weather']+"</p>"+
	"<p class='p_around'>"+info[i]['winddirection']+"("+getWindLevel(info[i]['windspeed'])+"级)&nbsp;&nbsp;湿度"+info[i]['humi']+"%</p>"+
	"<table class='table_around_child'><tr>"+
	"<td><div style=' height:30px;width:20px; text-align:center; color:black;padding:3px 3px;'><img width='25px' src='../assets/aqilevel/aqilevel"+getPM25LevelIndex(info[i]['pm2_5'])+".png'></div></td><td>"+info[i]['pm2_5']+"<br>PM2.5</td><td><div style=' height:30px;width:20px; text-align:center; color:black;padding:3px 3px;'><img width='25px' src='../assets/aqilevel/aqilevel"+getPM10LevelIndex(info[i]['pm10'])+".png'></div></td><td>"+info[i]['pm10']+"<br>PM10</td>"+
	"</tr><tr>"+
	"<td><div style='height:30px;width:20px; text-align:center; color:black;padding:3px 3px;'><img width='25px' src='../assets/aqilevel/aqilevel"+getSO2LevelIndex(info[i]['so2'])+".png'></div></td><td>"+parseFloat(info[i]['so2']).toFixed(0)+"<br>SO2</td><td><div style='height:30px;width:20px; text-align:center; color:black;padding:3px 3px;'><img width='25px' src='../assets/aqilevel/aqilevel"+getCOLevelIndex(info[i]['co'])+".png'></div></td><td>"+parseFloat(info[i]['co']).toFixed(0)+"<br>CO</td>"+
	"</tr><tr>"+
	"<td><div style='height:30px;width:20px; text-align:center; color:black;padding:3px 3px;'><img width='25px' src='../assets/aqilevel/aqilevel"+getNO2LevelIndex(info[i]['no2'])+".png'></div></td><td>"+parseFloat(info[i]['no2']).toFixed(0)+"<br>NO2</td><td><div style='height:30px;width:20px; text-align:center; color:black;padding:3px 3px;'><img width='25px' src='../assets/aqilevel/aqilevel"+getNO2LevelIndex(info[i]['o3'])+".png'></div></td><td>"+parseFloat(info[i]['o3']).toFixed(0)+"<br>O3</td>"
	+"</tr><table>"
	+"</div></td>");
		j++;
		if(j==4){
		$("#table_around").append($tr);
		
		$tr=$("<tr></tr>");
		j=0;
	}
}
});


$("#table_around").on('mouseover','.td_around',function(){
//$('.td_around').find('.div_a_info').hide();
$(this).find('.div_a_info').show();
});

$("#table_around").on('mouseout','.td_around',function(){
	//$('.td_around').find('.div_a_info').hide();
	$(this).find('.div_a_info').hide();
});
	

 function getColorByAQI(aqi)
{
	var color="#6E6E6E";
   if(aqi<=0)
   {
     color = '#6E6E6E';
   }
   else if(aqi<=50)
   {
     color = '#43ce17';
   }
   else if(aqi<=100)
   {
    color = '#efdc31';
   }
   else if(aqi<=150)
   {
    color = '#fa0';
   }
   else if(aqi<=200)
   {
    color = '#ff401a';
   }
   else if(aqi<=300)
   {
    color = '#d20040';
   }
   else
   {
    color = '#9c0a4e';
   }
   return color;  
}

function getColorByQuality(quality)
{
   if(quality=='无'||quality=='')
   {
     color = '#6E6E6E';
   }
   else if(quality=='优')
   {
     color = '#43ce17';
   }
   else if(quality=='良')
   {
    color = '#efdc31';
   }
   else if(quality=='轻度污染')
   {
    color = '#fa0';
   }
   else if(quality=='中度污染')
   {
    color = '#ff401a';
   }
   else if(quality=='重度污染')
   {
    color = '#d20040';
   }
   else
   {
    color = '#9c0a4e';
   }
   return color;  
}
function getColorByAQI(aqi)
{
   if(aqi<=0)
   {
     color = '#6E6E6E';
   }
   else if(aqi<=50)
   {
     color = '#43ce17';
   }
   else if(aqi<=100)
   {
    color = '#efdc31';
   }
   else if(aqi<=150)
   {
    color = '#fa0';
   }
   else if(aqi<=200)
   {
    color = '#ff401a';
   }
   else if(aqi<=300)
   {
    color = '#d20040';
   }
   else
   {
    color = '#9c0a4e';
   }
   return color;  
}




function getlevelColor(level)
		{
		   if(level==0)
		   {
		     color = "#6E6E6E";
		   }
		   else if(level==1)
		   {
		     color = "#43ce17";
		   }
		   else if(level==2)
		   {
		    color = "#efdc31";
		   }
		   else if(level==3)
		   {
		    color = "#fa0";
		   }
		   else if(level==4)
		   {
		    color = "#ff401a";
		   }
		   else if(level==5)
		   {
		    color = "#d20040";
		   }
		   else
		   {
		    color = "#9c0a4e";
		   }
		   return color; 
		}
	
		function getPM25LevelIndex(pm2_5)
		{
		    if(pm2_5<=35)
		    {
		      level=1;
		    }
		    else if(pm2_5<=75)
		    {
		      level=2;
		    }
		    else if(pm2_5<=115)
		    {
		      level=3;
		    }
		    else if(pm2_5<150)
		    {
		      level=4;
		    }
		    else if(pm2_5<=250)
		    {
		      level=5;
		    }
		    else
		    {
		      level=6;
		    }
		    return level;
		}
		
		function getPM10LevelIndex(pm10)
		{
		    if(pm10<=50)
		    {
		      level=1;
		    }
		    else if(pm10<=150)
		    {
		      level=2;
		    }
		    else if(pm10<=250)
		    {
		      level=3;
		    }
		    else if(pm10<350)
		    {
		      level=4;
		    }
		    else if(pm10<=420)
		    {
		      level=5;
		    }
		    else
		    {
		      level=6;
		    }
		    return level;
		}
		
		function getSO2LevelIndex(so2)
		{
		    if(so2<=150)
		    {
		      level=1;
		    }
		    else if(so2<=500)
		    {
		      level=2;
		    }
		    else if(so2<=650)
		    {
		      level=3;
		    }
		    else if(so2<800)
		    {
		      level=4;
		    }
		    else
		    {
		      level=5;
		    }
		    return level;
		}
	
		function getNO2LevelIndex(no2)
		{
		    if(no2<=100)
		    {
		      level=1;
		    }
		    else if(no2<=200)
		    {
		      level=2;
		    }
		    else if(no2<=700)
		    {
		      level=3;
		    }
		    else if(no2<1200)
		    {
		      level=4;
		    }
		    else if(no2<2340)
		    {
		      level=5;
		    }
		    else
		    {
		      level=6;
		    }
		    return level;
		}

		function getO3LevelIndex(o3)
		{
		    if(o3<=160)
		    {
		      level=1;
		    }
		    else if(o3<=200)
		    {
		      level=2;
		    }
		    else if(o3<=300)
		    {
		      level=3;
		    }
		    else if(o3<400)
		    {
		      level=4;
		    }
		    else if(o3<800)
		    {
		      level=5;
		    }
		    else
		    {
		      level=6;
		    }
		    return level;
		}
		
		function getCOLevelIndex(co)
		{
		    if(co<=5)
		    {
		      level=1;
		    }
		    else if(co<=10)
		    {
		      level=2;
		    }
		    else if(co<=35)
		    {
		      level=3;
		    }
		    else if(co<60)
		    {
		      level=4;
		    }
		    else if(co<90)
		    {
		      level=5;
		    }
		    else
		    {
		      level=6;
		    }
		    return level;
		}
		
		/**
		 * 风速-》级别
		 */
		function getWindLevel(speed){
			if(speed<1){
				return 0;
			}else if(speed>=1&&speed<=5){
				return 1;
			}else if(speed>=6&&speed<=11){
				return 2;
			}else if(speed>=12&&speed<=19){
				return 3;
			}else if(speed>=20&&speed<=28){
				return 4;
			}else if(speed>=29&&speed<=38){
				return 5;
			}else if(speed>=39&&speed<=49){
				return 6;
			}else if(speed>=50&&speed<=61){
				return 7;
			}else if(speed>=62&&speed<=74){
				return 8;
			}else if(speed>=75&&speed<=88){
				return 9;
			}else if(speed>=89&&speed<=102){
				return 10;
			}else if(speed>=103&&speed<=117){
				return 11;
			}else if(speed>117){
				return 12;
			}
		}