/*city_compare_chart.js*/

var city1 = '北京';
var city2 = '上海';
var city3 = '杭州';

var type = 'HOUR';
var ITEM = 'AQI';
var DATE = 'DAY';

var data1AQI = [];
var data1PM25 = [];
var data1PM10 = [];
var data1CO = [];
var data1SO2 = [];
var data1NO2 = [];
var data1O3 = [];
var data1Index = [];
var data1Humi = [];
var data1Temp = [];
var data1Wind = [];

var data2AQI = [];
var data2PM25 = [];
var data2PM10 = [];
var data2CO = [];
var data2SO2 = [];
var data2NO2 = [];
var data2O3 = [];
var data2Index = [];
var data2Humi = [];
var data2Temp = [];
var data2Wind = [];

var data3AQI = [];
var data3PM25 = [];
var data3PM10 = [];
var data3CO = [];
var data3SO2 = [];
var data3NO2 = [];
var data3O3 = [];
var data3Index = [];
var data3Humi = [];
var data3Temp = [];
var data3Wind = [];


$(function() 
{                         
   Highcharts.setOptions({
      global: {
          useUTC: false
      }
   }); 
   if($.cookie('dcity1')!=null)
   {
      city1 = $.cookie('dcity1');
   }
   if($.cookie('dcity2')!=null)
   {
      city2 = $.cookie('dcity2');
   }
   if($.cookie('dcity3')!=null)
   {
      city3 = $.cookie('dcity3');
   }

   $('#city1').attr('value',city1);
   $('#city2').attr('value',city2);
   $('#city3').attr('value',city3);

   var citysel1=new Vcity.CitySelector({input:'city1'});  
   var citysel2=new Vcity.CitySelector({input:'city2'});
   var citysel3=new Vcity.CitySelector({input:'city3'});
   getTimeSelect();
   $('#myTab1 a:first').tab('show');//初始化显示哪个tab 
  
   $('#myTab1 a').click(function (e) { 
      e.preventDefault();//阻止a链接的跳转行为 
      $(this).tab('show');//显示当前选中的链接及关联的content
   }); 

   $(".btndategroup1:eq(0)").addClass("btnbd-success");
   $(".btndategroup1").click(function()
  {
        DATE = $(this).val();
        $(".btndategroup1").removeClass("btnbd-success");
        $(this).addClass("btnbd-success");

        if(DATE=="DAY")
        {
          $(".btntypegroup1").removeClass("btnbd-success");
          $(".btntypegroup1:eq(0)").addClass("btnbd-success");
          type = "HOUR";
        }
        else if(DATE=="WEEK" && type=="MONTH")
        {
          $(".btntypegroup1").removeClass("btnbd-success");
          $(".btntypegroup1:eq(0)").addClass("btnbd-success");
          type = "HOUR";
        }
        else if(DATE=="MONTH" && (type=="HOUR" || type=="MONTH"))
        {
          $(".btntypegroup1").removeClass("btnbd-success");
          $(".btntypegroup1:eq(1)").addClass("btnbd-success");
          type = "DAY";
        }
        else if(DATE=="YEAR" && type=="HOUR")
        {
          $(".btntypegroup1").removeClass("btnbd-success");
          $(".btntypegroup1:eq(1)").addClass("btnbd-success");
          type = "DAY";
        }
        getTimeSelect();
    });

   $(".btntypegroup1:eq(0)").addClass("btnbd-success");
   $(".btntypegroup1").click(function()
  {
        type = $(this).val();
        $(".btntypegroup1").removeClass("btnbd-success");
        $(this).addClass("btnbd-success");

        if(type=="HOUR" && DATE=="YEAR")
        {
          $(".btndategroup1").removeClass("btnbd-success");
          $(".btndategroup1:eq(0)").addClass("btnbd-success");
          DATE = "DAY";
        }
        else if(type=="DAY" && DATE=="DAY")
        {
          $(".btndategroup1").removeClass("btnbd-success");
          $(".btndategroup1:eq(1)").addClass("btnbd-success");
          DATE = "MONTH";
        }
        else if(type=="MONTH" && (DATE=="DAY" || DATE=="WEEK" || DATE=="MONTH"))
        {
          $(".btndategroup1").removeClass("btnbd-success");
          $(".btndategroup1:eq(3)").addClass("btnbd-success");
          DATE = "YEAR";
        }
        getTimeSelect();
    });

   $(".btnitemgroup1:first").addClass("btnbd-success");
   $(".btnitemgroup1").click(function()
  {
        ITEM = $(this).val();
        $(".btnitemgroup1").removeClass("btnbd-success");
        $(this).addClass("btnbd-success");
        showChartByItem();
    });
}); 

function initDatePicker()
{

  $('#reservation').daterangepicker(
  { 
    format: 'YYYY-MM-DD'
  },
  function(start, end, label) {
    //alert('A date range was chosen: ' + start.format('YYYY-MM-DD') + ' to ' + end.format('YYYY-MM-DD'));
    startTime = new Date(start.format('YYYY-MM-DD'));
    endTime = new Date(end.format('YYYY-MM-DD'));

    dateDiff = Math.floor((endTime.getTime()-startTime.getTime())/(24*3600*1000));
    $(".btndategroup1").removeClass("btnbd-success");
    if(dateDiff>30 && type == "HOUR")
    {
      $(".btntypegroup1").removeClass("btnbd-success");
      $(".btntypegroup1:eq(1)").addClass("btnbd-success");
      type = "DAY";
    }
    else if(dateDiff<=2 && (type == "DAY" || type=="MONTH"))
    {
      $(".btntypegroup1").removeClass("btnbd-success");
      $(".btntypegroup1:eq(0)").addClass("btnbd-success");
      type = "HOUR";
    }
    else if(dateDiff<30 && type=="MONTH")
    {
      $(".btntypegroup1").removeClass("btnbd-success");
      $(".btntypegroup1:eq(1)").addClass("btnbd-success");

      type = "DAY";
    }
    //getChartData(start.format('YYYY-MM-DD'),end.format('YYYY-MM-DD'));
    startTime = start.format('YYYY-MM-DD');
    endTime = end.format('YYYY-MM-DD');
    getData();
  }
  );
}

function getTimeSelect()
{

  startTime = new Date(); 
  if(DATE=="DAY")
  {
    startTime.setHours(startTime.getHours() - 27);
    startTime.setMinutes(0);
    startTime.setSeconds(0);
    //type ="HOUR"; 
    //$(".btntypegroup1:first").addClass("btnbd-success");
  }
  else if(DATE=="WEEK")
  {
    startTime.setDate(startTime.getDate() - 7 );
    startTime.setHours(0);
    startTime.setMinutes(0);
    startTime.setSeconds(0);
    //type ="HOUR"; 
    //$(".btntypegroup1:first").addClass("btnbd-success");
  }
  else if(DATE=="MONTH")
  {
    startTime.setMonth(startTime.getMonth() - 1);
    startTime.setHours(0);
    startTime.setMinutes(0);
    startTime.setSeconds(0);
    //type="DAY";
    //$(".btntypegroup1:second").addClass("btnbd-success");
  }
  else if(DATE=="YEAR")
  {
    startTime.setMonth(startTime.getMonth() - 12);
    startTime.setMonth(0);
    startTime.setDate(1);
    startTime.setHours(0);
    startTime.setMinutes(0);
    startTime.setSeconds(0);
    //type="DAY";
    //$(".btntypegroup1:last").addClass("btnbd-success");
  }                     
  endTime = new Date();

  startDate = startTime.pattern('yyyy-MM-dd');
  endDate = endTime.pattern('yyyy-MM-dd');
  startTime = startTime.pattern('yyyy-MM-dd HH:mm:ss');
  endTime = endTime.pattern('yyyy-MM-dd HH:mm:ss');

   //startDate = '2014-03-05';
   //endDate = '2015-03-06';
   $('#reservation').val(startDate + ' - ' + endDate);
   $('#reservation').daterangepicker({ startDate: startDate, endDate: endDate});
   //$('#reservation').data('daterangepicker').setStartDate(startDate);
   //$('#reservation').data('daterangepicker').setEndDate(endDate);
   initDatePicker();
   getData();

   
}

function getData()
{
   city1=$('#city1').val();
   $.cookie('dcity1', city1, {expires : 30});
   city2=$('#city2').val();
   $.cookie('dcity2', city2, {expires : 30});
   city3=$('#city3').val();
   $.cookie('dcity3', city3, {expires : 30});




   $.ajax({             
        url: 'city_compare_chart',
        data:{
              'city1':city1,
              'city2':city2,
              'city3':city3,
              'type':type,
              'startTime':startTime,
              'endTime':endTime},
        type: "get", 
        dataType : "json",           
        success: function (data) { 
          if(data.rows.length>0)
      {
        data1AQI.splice(0, data1AQI.length);
        data1PM25.splice(0, data1PM25.length);
        data1PM10.splice(0, data1PM10.length);
        data1CO.splice(0, data1CO.length);
        data1NO2.splice(0, data1NO2.length);
        data1O3.splice(0, data1O3.length);
        data1SO2.splice(0, data1SO2.length);
        data1Index.splice(0, data1Index.length);
        data1Temp.splice(0, data1Temp.length);
        data1Humi.splice(0, data1Humi.length);
        data1Wind.splice(0, data1Wind.length);

        data2AQI.splice(0, data2AQI.length);
        data2PM25.splice(0, data2PM25.length);
        data2PM10.splice(0, data2PM10.length);
        data2CO.splice(0, data2CO.length);
        data2NO2.splice(0, data2NO2.length);
        data2O3.splice(0, data2O3.length);
        data2SO2.splice(0, data2SO2.length);
        data2Index.splice(0, data2Index.length);
        data2Temp.splice(0, data2Temp.length);
        data2Humi.splice(0, data2Humi.length);
        data2Wind.splice(0, data2Wind.length);

        data3AQI.splice(0, data3AQI.length);
        data3PM25.splice(0, data3PM25.length);
        data3PM10.splice(0, data3PM10.length);
        data3CO.splice(0, data3CO.length);
        data3NO2.splice(0, data3NO2.length);
        data3O3.splice(0, data3O3.length);
        data3Index.splice(0, data3Index.length);
        data3SO2.splice(0, data3SO2.length);
        data3Temp.splice(0, data3Temp.length);
        data3Humi.splice(0, data3Humi.length);
        data3Wind.splice(0, data3Wind.length);

        for(i=0;i<data.rows.length;i++)
        {
          citynum = data.rows[i].alldata.city_id;
          time = data.rows[i].timeformatted;
          aqi = parseInt(data.rows[i].alldata.AQI);
          pm2_5 = parseInt(data.rows[i].alldata.pm25);
          pm10 = parseInt(data.rows[i].alldata.pm10);
          co = parseFloat((parseFloat(data.rows[i].alldata.CO)).toFixed(3));
          no2 = parseInt(data.rows[i].alldata.NO2);
          o3 = parseInt(data.rows[i].alldata.O3);
          so2 = parseInt(data.rows[i].alldata.SO2);
          complexindex = parseFloat((parseFloat(data.rows[i].alldata.zonghezhishu)).toFixed(3));
          temp = parseInt(data.rows[i].alldata.temp);
          humi = parseInt(data.rows[i].alldata.humi);
          wind = parseInt(data.rows[i].alldata.windscale);
          winddirection = data.rows[i].alldata.winddirection;
          wdurl = getWindDirectionUrl(winddirection);

          primary_pollutant = data.rows[i].alldata.main_pol;

          aqiIndex = getAQILevelIndex(aqi);
          pm25Index = getPM25LevelIndex(pm2_5);
          pm10Index = getPM10LevelIndex(pm10);
          coIndex = getCOLevelIndex(co);
          no2Index = getNO2LevelIndex(no2);
          o3Index = getO3LevelIndex(o3);
          so2Index = getSO2LevelIndex(so2);

          if(citynum==data.citynum[0])
          {
            data1AQI.push({
                     x: converTimeFormat(time).getTime(),
                     y: aqi,
                     color:getColorByIndex(aqiIndex),
                     primary_pollutant:primary_pollutant
                  });
                  data1PM25.push({
                    x: converTimeFormat(time).getTime(),
                    y: pm2_5,
                    color:getColorByIndex(pm25Index)
                  });
                  data1PM10.push({
                    x: converTimeFormat(time).getTime(),
                    y: pm10,
                    color:getColorByIndex(pm10Index)
                  });
                  data1CO.push({
                    x: converTimeFormat(time).getTime(),
                    y: co,
                    color:getColorByIndex(coIndex)
                  });
                  data1NO2.push({
                    x: converTimeFormat(time).getTime(),
                    y: no2,
                    color:getColorByIndex(no2Index)
                  });
                  data1O3.push({
                    x: converTimeFormat(time).getTime(),
                    y: o3,
                    color:getColorByIndex(o3Index)
                  });
                  data1SO2.push({
                    x: converTimeFormat(time).getTime(),
                    y: so2,
                    color:getColorByIndex(so2Index)
                  });
                  data1Index.push({
                    x: converTimeFormat(time).getTime(),
                    y: complexindex
                  });
                  if(temp>-100 && temp< 200)
                  data1Temp.push({
                    x: converTimeFormat(time).getTime(),
                    y: temp
                  });
                if(humi>0)
                  data1Humi.push({
                    x: converTimeFormat(time).getTime(),
                    y: humi
                  });
                  if(wind>0)
                  data1Wind.push({
                    x: converTimeFormat(time).getTime(),
                    y: wind,
                    marker:{symbol: wdurl},
                    winddirection:winddirection,
                    weather:data.rows[i].weather
                  });
              }
              else if(citynum==data.citynum[1])
          {
            data2AQI.push({
                     x: converTimeFormat(time).getTime(),
                     y: aqi,
                     color:getColorByIndex(aqiIndex),
                     primary_pollutant:primary_pollutant
                  });
                  data2PM25.push({
                    x: converTimeFormat(time).getTime(),
                    y: pm2_5,
                    color:getColorByIndex(pm25Index)
                  });
                  data2PM10.push({
                    x: converTimeFormat(time).getTime(),
                    y: pm10,
                    color:getColorByIndex(pm10Index)
                  });
                  data2CO.push({
                    x: converTimeFormat(time).getTime(),
                    y: co,
                    color:getColorByIndex(coIndex)
                  });
                  data2NO2.push({
                    x: converTimeFormat(time).getTime(),
                    y: no2,
                    color:getColorByIndex(no2Index)
                  });
                  data2O3.push({
                    x: converTimeFormat(time).getTime(),
                    y: o3,
                    color:getColorByIndex(o3Index)
                  });
                  data2SO2.push({
                    x: converTimeFormat(time).getTime(),
                    y: so2,
                    color:getColorByIndex(so2Index)
                  });
                  data2Index.push({
                    x: converTimeFormat(time).getTime(),
                    y: complexindex
                  });
                  if(temp>-100 && temp< 200)
                  data2Temp.push({
                    x: converTimeFormat(time).getTime(),
                    y: temp
                  });
                if(humi>0)
                  data2Humi.push({
                    x: converTimeFormat(time).getTime(),
                    y: humi
                  });
                  if(wind>0)
                  data2Wind.push({
                    x: converTimeFormat(time).getTime(),
                    y: wind,
                    marker:{symbol: wdurl},
                    winddirection:winddirection,
                    weather:data.rows[i].weather
                  });
              }
              else if(citynum==data.citynum[2])
          {
            data3AQI.push({
                     x: converTimeFormat(time).getTime(),
                     y: aqi,
                     color:getColorByIndex(aqiIndex),
                     primary_pollutant:primary_pollutant
                  });
                  data3PM25.push({
                    x: converTimeFormat(time).getTime(),
                    y: pm2_5,
                    color:getColorByIndex(pm25Index)
                  });
                  data3PM10.push({
                    x: converTimeFormat(time).getTime(),
                    y: pm10,
                    color:getColorByIndex(pm10Index)
                  });
                  data3CO.push({
                    x: converTimeFormat(time).getTime(),
                    y: co,
                    color:getColorByIndex(coIndex)
                  });
                  data3NO2.push({
                    x: converTimeFormat(time).getTime(),
                    y: no2,
                    color:getColorByIndex(no2Index)
                  });
                  data3O3.push({
                    x: converTimeFormat(time).getTime(),
                    y: o3,
                    color:getColorByIndex(o3Index)
                  });
                  data3SO2.push({
                    x: converTimeFormat(time).getTime(),
                    y: so2,
                    color:getColorByIndex(so2Index)
                  });
                  data3Index.push({
                    x: converTimeFormat(time).getTime(),
                    y: complexindex
                  });
                  if(temp>-100 && temp< 200)
                  data3Temp.push({
                    x: converTimeFormat(time).getTime(),
                    y: temp
                  });
                if(humi>0)
                  data3Humi.push({
                    x: converTimeFormat(time).getTime(),
                    y: humi
                  });
                  if(wind>0)
                  data3Wind.push({
                    x: converTimeFormat(time).getTime(),
                    y: wind,
                    marker:{symbol: wdurl},
                    winddirection:winddirection,
                    weather:data.rows[i].weather
                  });
              } 
       }
       showChartByItem();
      }
        }
    });
}

function showChartByItem()
{
  var radioArray,dataArray,labelStr=ITEM;
  switch(ITEM)
  {
    case "AQI":data1Array =data1AQI;data2Array =data2AQI;data3Array =data3AQI;unit="";break;
    case "PM2.5":data1Array =data1PM25;data2Array =data2PM25;data3Array =data3PM25;unit="ug/m<sup>3<sup/>";break;
    case "PM10":data1Array =data1PM10;data2Array =data2PM10;data3Array =data3PM10;unit="ug/m<sup>3<sup/>";break;
    case "SO2":data1Array =data1SO2;data2Array =data2SO2;data3Array =data3SO2;unit="ug/m<sup>3<sup/>";break;
    case "NO2":data1Array =data1NO2;data2Array =data2NO2;data3Array =data3NO2;unit="ug/m<sup>3<sup/>";break;
    case "CO":data1Array =data1CO;data2Array =data2CO;data3Array =data3CO;unit="mg/m<sup>3<sup/>";break;
    case "O3":data1Array =data1O3;data2Array =data2O3;data3Array =data3O3;unit="ug/m<sup>3<sup/>";break;
    case "INDEX":data1Array =data1Index;data2Array =data2Index;data3Array =data3Index;unit="";labelStr="综合指数";break;
    case "TEMP":data1Array =data1Temp;data2Array =data2Temp;data3Array =data3Temp;unit="℃";labelStr="温度";break;
    case "HUMI":data1Array =data1Humi;data2Array =data2Humi;data3Array =data3Humi;unit="%";labelStr="湿度";break;
    case "WIND":data1Array =data1Wind;data2Array =data2Wind;data3Array =data3Wind;unit="级";labelStr="风级";break;
  }
  showLineChartCompare('chart',labelStr,city1,city2,city3,data1Array,data2Array,data3Array,unit,type);  
}