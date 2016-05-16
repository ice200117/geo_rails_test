// 秦皇岛历史数据变化展示


var city = '秦皇岛';
var type="HOUR";
var ITEM1="AQI";
var DATE1="DAY";
var dataAQI = [];var dataPM25 = [];var dataPM10 = [];var dataCO = [];var dataSO2 = [];var dataNO2 = [];var dataO3 = [];
var dataIndex = [];var dataHumi = [];var dataTemp = [];var dataWind = [];
var radioAQI = [];var radioPM25 = [];var radioPM10 = [];var radioCO = [];var radioSO2 = [];var radioNO2 = [];var radioO3 = [];
var levelArray =['无','优','良','轻度污染','中度污染','重度污染','严重污染'];
var startTime;
var endTime;
var startDate;
var endDate;

setTimeout('$(".btndategroup1:eq(0)").click()',200);
$(function(){
    Highcharts.setOptions({
        global: {
            useUTC: false
        }
    }); 
    $(".btndategroup1:eq(0)").addClass("btnbd-info");
    $(".btndategroup1").click(function()
	 {
        DATE1 = $(this).val();
        $(".btndategroup1").removeClass("btnbd-info");
        $(this).addClass("btnbd-info");

        if(DATE1=="DAY")
        {
        	$(".btntypegroup1").removeClass("btnbd-info");
        	$(".btntypegroup1:eq(0)").addClass("btnbd-info");
        	type = "HOUR";
        }
        else if(DATE1=="WEEK" && type=="MONTH")
        {
        	$(".btntypegroup1").removeClass("btnbd-info");
        	$(".btntypegroup1:eq(0)").addClass("btnbd-info");
        	type = "HOUR";
        }
        else if(DATE1=="MONTH" && (type=="HOUR" || type=="MONTH"))
        {
        	$(".btntypegroup1").removeClass("btnbd-info");
        	$(".btntypegroup1:eq(1)").addClass("btnbd-info");
        	type = "DAY";
        }
        else if(DATE1=="YEAR" && type=="HOUR")
        {
        	$(".btntypegroup1").removeClass("btnbd-info");
        	$(".btntypegroup1:eq(1)").addClass("btnbd-info");
        	type = "DAY";
        }
        getTimeSelect();
    });

   $(".btntypegroup1:eq(0)").addClass("btnbd-info");
   $(".btntypegroup1").click(function()
	 {
        type = $(this).val();
        $(".btntypegroup1").removeClass("btnbd-info");
        $(this).addClass("btnbd-info");

        if(type=="HOUR" && DATE1=="YEAR")
        {
        	$(".btndategroup1").removeClass("btnbd-info");
        	$(".btndategroup1:eq(0)").addClass("btnbd-info");
        	DATE1 = "DAY";
        }
        else if(type=="DAY" && DATE1=="DAY")
        {
        	$(".btndategroup1").removeClass("btnbd-info");
        	$(".btndategroup1:eq(1)").addClass("btnbd-info");
        	DATE1 = "MONTH";
        }
        else if(type=="MONTH" && (DATE1=="DAY" || DATE1=="WEEK"  || DATE1=="MONTH"))
        {
        	$(".btndategroup1").removeClass("btnbd-info");
        	$(".btndategroup1:eq(3)").addClass("btnbd-info");
        	DATE1 = "YEAR";
        }
        getTimeSelect();
    });

   $(".btnitemgroup1:first").addClass("btnbd-info");
   $(".btnitemgroup1").click(function()
	 {
        ITEM1 = $(this).val();
        $(".btnitemgroup1").removeClass("btnbd-info");
        $(this).addClass("btnbd-info");
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
      if(dateDiff>30 && type == "HOUR")
      {
        $(".btntypegroup1").removeClass("btnbd-info");
        $(".btntypegroup1:eq(1)").addClass("btnbd-info");
        type = "DAY";
      }
      else if(dateDiff<=2 && (type == "DAY" || type=="MONTH"))
      {
        $(".btntypegroup1").removeClass("btnbd-info");
        $(".btntypegroup1:eq(0)").addClass("btnbd-info");
        type = "HOUR";
      }
      else if(dateDiff<30 && type=="MONTH")
      {
        $(".btntypegroup1").removeClass("btnbd-info");
        $(".btntypegroup1:eq(1)").addClass("btnbd-info");
        type = "DAY";
      }
      startTime = start.format('YYYY-MM-DD');
      endTime = end.format('YYYY-MM-DD');
      getChartData(start.format('YYYY-MM-DD'),end.format('YYYY-MM-DD'));
    }
    );
}

function getTimeSelect()
{

    startTime = new Date(); 
    if(DATE1=="DAY")
    {
        startTime.setHours(startTime.getHours() - 27);
        startTime.setMinutes(0);
    }
    else if(DATE1=="WEEK")
    {
        startTime.setDate(startTime.getDate() - 7 );
        startTime.setHours(0);
        startTime.setMinutes(0);
        startTime.setSeconds(0);
    }
    else if(DATE1=="MONTH")
    {
        startTime.setMonth(startTime.getMonth() - 1);
        startTime.setHours(0);
        startTime.setMinutes(0);
        startTime.setSeconds(0);
    }
    else if(DATE1=="YEAR")
    {
        startTime.setMonth(startTime.getMonth() - 12);
        startTime.setMonth(0);
        startTime.setDate(1);
        startTime.setHours(0);
        startTime.setMinutes(0);
        startTime.setSeconds(0);
    }                     
    endTime = new Date();

    startDate = startTime.pattern('yyyy-MM-dd');
    endDate = endTime.pattern('yyyy-MM-dd');
    startTime = startTime.pattern('yyyy-MM-dd HH:mm:ss');
    endTime = endTime.pattern('yyyy-MM-dd HH:mm:ss');

     $('#reservation').val(startDate + ' - ' + endDate);
     $('#reservation').daterangepicker({ startDate: startDate, endDate: endDate});
     initDatePicker();
     getChartData(startTime,endTime);

     
}
/*
秦皇岛历史数据变化
 * */
function getChartData(startTime,endTime)
{  
 
  $.ajax({              
      url: '/qinhuangdao/get_linechart_data',
      data:{
            'city': city,
            'type': type,
            'startTime': startTime,
            'endTime': endTime},
      type: "get", 
      dataType : "json",               
      success: function (data) {  
        
        if(data.total>0)
              {
              dataAQI.splice(0, dataAQI.length);
              dataPM25.splice(0, dataPM25.length);
              dataPM10.splice(0, dataPM10.length);
              dataCO.splice(0, dataCO.length);
              dataNO2.splice(0, dataNO2.length);
              dataO3.splice(0, dataO3.length);
              dataSO2.splice(0, dataSO2.length);
              dataIndex.splice(0, dataIndex.length);
              dataTemp.splice(0, dataTemp.length);
              dataHumi.splice(0, dataHumi.length);
              dataWind.splice(0, dataWind.length);
              radioAQI.splice(0, radioAQI.length);
              radioPM25.splice(0, radioPM25.length);
              radioPM10.splice(0, radioPM10.length);
              radioCO.splice(0, radioCO.length);
              radioNO2.splice(0, radioNO2.length);
              radioO3.splice(0, radioO3.length);
              radioSO2.splice(0, radioSO2.length);
              countAQI = [];
              countPM25 = [];
              countPM10 = [];
              countCO = [];
              countNO2 = [];
              countO3 = [];
              countSO2 = [];
              for(i=1;i<=6;i++)
              {
                countAQI[i]=0;
                countPM25[i]=0;
                countPM10[i]=0;
                countCO[i]=0;
                countSO2[i]=0;
                countNO2[i]=0;
                countO3[i]=0;
              }

              for(i=0;i<data.rows.length;i++)
              {
                  aqi = parseInt(data.rows[i].aqi);
                  pm2_5 = parseInt(data.rows[i].pm2_5);
                  pm10 = parseInt(data.rows[i].pm10);
                  co = parseFloat((parseFloat(data.rows[i].co)).toFixed(2));
                  no2 = parseInt(data.rows[i].no2);
                  o3 = parseInt(data.rows[i].o3);
                  so2 = parseInt(data.rows[i].so2);
                  complexindex = parseFloat((parseFloat(data.rows[i].complexindex)).toFixed(3));
                  temp = parseInt(data.rows[i].temp);
                  humi = parseInt(data.rows[i].humi);
                  wind = parseInt(data.rows[i].windlevel);
                  winddirection = data.rows[i].winddirection;
                  wdurl = getWindDirectionUrl(winddirection);

                  primary_pollutant = data.rows[i].primary_pollutant;

                  aqiIndex = getAQILevelIndex(aqi);
                  countAQI[aqiIndex]++;

                  pm25Index = getPM25LevelIndex(pm2_5);
                  countPM25[pm25Index]++;

                  pm10Index = getPM10LevelIndex(pm10);
                  countPM10[pm10Index]++;

                  coIndex = getCOLevelIndex(co);
                  countCO[coIndex]++;

                  no2Index = getNO2LevelIndex(no2);
                  countNO2[no2Index]++;

                  o3Index = getO3LevelIndex(o3);
                  countO3[o3Index]++;

                  so2Index = getSO2LevelIndex(so2);
                  countSO2[so2Index]++;

                  dataAQI.push({
                     x: converTimeFormat(data.rows[i].time).getTime(),
                     y: aqi,
                     color:getColorByIndex(aqiIndex),
                     primary_pollutant:primary_pollutant
                  });
                  dataPM25.push({
                    x: converTimeFormat(data.rows[i].time).getTime(),
                    y: pm2_5,
                    color:getColorByIndex(pm25Index)
                  });
                  dataPM10.push({
                    x: converTimeFormat(data.rows[i].time).getTime(),
                    y: pm10,
                    color:getColorByIndex(pm10Index)
                  });
                  dataCO.push({
                    x: converTimeFormat(data.rows[i].time).getTime(),
                    y: co,
                    color:getColorByIndex(coIndex)
                  });
                  dataNO2.push({
                    x: converTimeFormat(data.rows[i].time).getTime(),
                    y: no2,
                    color:getColorByIndex(no2Index)
                  });
                  dataO3.push({
                    x: converTimeFormat(data.rows[i].time).getTime(),
                    y: o3,
                    color:getColorByIndex(o3Index)
                  });
                  dataSO2.push({
                    x: converTimeFormat(data.rows[i].time).getTime(),
                    y: so2,
                    color:getColorByIndex(so2Index)
                  });
                  dataIndex.push({
                    x: converTimeFormat(data.rows[i].time).getTime(),
                    y: complexindex
                  });
                  if(temp>-100 && temp< 200)
                  dataTemp.push({
                    x: converTimeFormat(data.rows[i].time).getTime(),
                    y: temp
                  });
                  if(humi>0)
                  dataHumi.push({
                    x: converTimeFormat(data.rows[i].time).getTime(),
                    y: humi
                  });
                  if(wind>0)
                  dataWind.push({
                    x: converTimeFormat(data.rows[i].time).getTime(),
                    y: wind,
                    marker:{symbol: wdurl},
                    winddirection:winddirection,
                    weather:data.rows[i].weather
                  });
             }
             for(i=1;i<=6;i++)
             {
                if(countAQI[i]>=0)
                {
                    radioAQI.push({
                      name:levelArray[i],
                      color:getColorByIndex(i),
                      y:countAQI[i]
                    });
                }
                if(countPM25[i]>=0)
                {
                    radioPM25.push({
                      name:levelArray[i],
                      color:getColorByIndex(i),
                      y:countPM25[i]
                    });
                }
                if(countPM10[i]>=0)
                {
                    radioPM10.push({
                      name:levelArray[i],
                      color:getColorByIndex(i),
                      y:countPM10[i]
                    });
                }
                if(countNO2[i]>=0)
                {
                    radioNO2.push({
                      name:levelArray[i],
                      color:getColorByIndex(i),
                      y:countNO2[i]
                    });
                }
                if(countSO2[i]>=0)
                {
                    radioSO2.push({
                      name:levelArray[i],
                      color:getColorByIndex(i),
                      y:countSO2[i]
                    });
                }
                if(countCO[i]>=0)
                {
                    radioCO.push({
                      name:levelArray[i],
                      color:getColorByIndex(i),
                      y:countCO[i]
                    });
                }
                if(countO3[i]>=0)
                {
                    radioO3.push({
                      name:levelArray[i],
                      color:getColorByIndex(i),
                      y:countO3[i]
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
    var radioArray,dataArray,labelStr=ITEM1;

    switch(ITEM1)
    {
        case "AQI":dataArray =dataAQI;radioArray=radioAQI;unit="";break;
        case "TOTAL":radioArray=radioAQI;unit="";break;
        case "PM2.5":dataArray =dataPM25;radioArray=radioPM25;unit="ug/m<sup>3<sup/>";break;
        case "PM10":dataArray =dataPM10;radioArray=radioPM10;unit="ug/m<sup>3<sup/>";break;
        case "SO2":dataArray =dataSO2;radioArray=radioSO2;unit="ug/m<sup>3<sup/>";break;
        case "NO2":dataArray =dataNO2;radioArray=radioNO2;unit="ug/m<sup>3<sup/>";break;
        case "CO":dataArray =dataCO;radioArray=radioCO;unit="mg/m<sup>3<sup/>";break;
        case "O3":dataArray =dataO3;radioArray=radioO3;unit="ug/m<sup>3<sup/>";break;
        case "INDEX":dataArray =dataIndex;radioArray=null;unit="";labelStr="综合指数";break;
        case "TEMP":dataArray =dataTemp;radioArray=null;unit="℃";labelStr="温度";break;
        case "HUMI":dataArray =dataHumi;radioArray=null;unit="%";labelStr="湿度";break;
        case "WIND":dataArray =dataWind;radioArray=null;unit="级";labelStr="风级";break;
    }
    if(ITEM1=="AQI")
    {
        showLineChart('chart',ITEM1,dataArray,unit,type);
    }
    // else if(ITEM1=='INDEX')
    // {
    //  showLineChart('chart','综合指数',dataArray,unit,type);
    // }
    else if(ITEM1=="TOTAL")
    {
        showLineChartAll('chart',type,dataAQI,dataPM25,dataPM10,dataSO2,dataNO2,dataCO,dataO3,dataTemp,dataHumi,dataWind);
    }
    else
    {
        showLineChartWithAQI('chart',labelStr,dataArray,dataAQI,unit,type);
    }
    if(radioArray!=null)
    showPieChart('piechart',ITEM1,radioArray);
    
}
