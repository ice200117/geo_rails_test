/*秦皇岛历史排名曲线js*/


  var ITEM3="DESC";var DATE3="MONTH";
  var startTime,endTime;var ranktype="DAY";var city = "秦皇岛";
  var dataRank = [];var dataLastRank = [];var num=0;var lastnum=0;
  setTimeout('$(".btndategroup3:last").click()',200);
   $(".btnitemgroup3:last").addClass("btnbd-info");
   $(".btnitemgroup3").click(function()
	 {        
        $(".btnitemgroup3").removeClass("btnbd-info");
        $(this).addClass("btnbd-info");
        ITEM3 = $(this).val();
        showRankChartByItem();
    });

   $(".btndategroup3:last").addClass("btnbd-info");
   $(".btndategroup3").click(function()
	 {
        $(".btndategroup3").removeClass("btnbd-info");
        $(this).addClass("btnbd-info");
        DATE3 = $(this).val();
        getRankData();        
    });
function getRankData()
{
  startTime = new Date(); 
  if(DATE3=="DAY")
  {
    startTime.setMonth(startTime.getMonth() - 1);
    startTime.setHours(0);
    startTime.setMinutes(0);
    startTime.setSeconds(0);
    ranktype ="DAY"; 
  }
  else if(DATE3=="MONTH")
  {
    startTime.setMonth(startTime.getMonth() - 12);
    startTime.setHours(0);
    startTime.setMinutes(0);
    startTime.setSeconds(0);
    ranktype="MONTH";
  }
                
  endTime = new Date();
  startTime = startTime.pattern('yyyy-MM-dd HH:mm:ss');
  endTime = endTime.pattern('yyyy-MM-dd HH:mm:ss');
  $.ajax({            
	  url: '/qinhuangdao/get_rank_chart_data',
      data:{
            'city':city,
            'type':ranktype,
            'startTime':startTime,
            'endTime':endTime},
      type: "get",
      dataType : "json",            
      success: function (data) {  
        
        if(data.total>0)
        {
          dataRank.splice(0, dataRank.length);
          dataLastRank.splice(0, dataLastRank.length);
          num=0;
          lastnum=0;
          primary_pollutant='';
          for(i=0;i<data.rows.length;i++)
          {
            if(ranktype=="DAY")
            {
              time = converTimeFormat(data.rows[i].time).getTime();
              rank = (data.rows[i].rank==null)?null:parseInt(data.rows[i].rank);
              lastrank = (data.rows[i].lastrank==null)?null:parseInt(data.rows[i].lastrank);
              index_num = (data.rows[i].aqi==null)?null:parseInt(data.rows[i].aqi);
              if(data.rows[i].primary_pollutant!=null)
              primary_pollutant = (data.rows[i].primary_pollutant).toUpperCase();
              label = '真气排名';
            }
            else if(ranktype=="MONTH")
            {
              if(data.rows[i].time!=null)
              {
                time = convertMonthFormat(data.rows[i].time).getTime();
                rank = (data.rows[i].rank==null)?null:parseInt(data.rows[i].rank);
                lastrank = (data.rows[i].lastrank==null)?null:parseInt(data.rows[i].lastrank);
                index_num = (data.rows[i].complexindex==null)?null:parseFloat(data.rows[i].complexindex);
                if(data.rows[i].primary_pollutant!=null)
                  primary_pollutant = (data.rows[i].primary_pollutant).toUpperCase();
                label = '官方排名';
              }
              else
              { 
                time = convertMonthFormat(data.rows[i].foretime).getTime();
                rank = (data.rows[i].forerank==null)?null:parseInt(data.rows[i].forerank);
                lastrank = (data.rows[i].forelastrank==null)?null:parseInt(data.rows[i].forelastrank);
                index_num = (data.rows[i].forecomplexindex==null)?null:parseFloat(data.rows[i].forecomplexindex);
                if(data.rows[i].foreprimary_pollutant!=null)
                  primary_pollutant = (data.rows[i].foreprimary_pollutant).toUpperCase();
                label = '预测排名';
              }
            }
            
            if(rank<=10)
            {
              num++;
              color='green';
            }
            else
            {
              color='#2894FF';
            }
            
            if(lastrank<=10)
            {
              lastnum++;
            lastcolor='red';
            }
            else
            {
              lastcolor='#2894FF';
            }
			dataRank.push({
				x: time,
				y: rank,
				color:color,
				type:label,
				index_num:index_num,
				primary_pollutant:primary_pollutant
			});
			dataLastRank.push({
				x: time,
				y: lastrank,
				color:lastcolor,
				type:label,
				index_num:index_num,
				primary_pollutant:primary_pollutant
			});

          }
          showRankChartByItem();
          }
          else
          {
            $('#cityranktab').hide();
          }
        }
    });
}

function showRankChartByItem()
{
  var item;
  switch(ITEM3)
  {
    case "ASC": item="排名";dataArray=dataRank;subtitle="共有" + num + "次进入前十名"; break;
    case "DESC": item="倒数排名"; dataArray=dataLastRank;subtitle="共有" + lastnum + "次进入倒数前十名";break;
  }
  showRankChart('rankchart',city,item,dataArray,"名",ranktype,subtitle);
}
