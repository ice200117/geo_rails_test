// map.js
var map=null;
var myGeo=null;
// initMap
function initMap(id,city,level,minzoom,maxzoom)
{
  try
  {
		if(map==null)
	  {
			  map = new BMap.Map(id,{minZoom:minzoom,maxZoom:maxzoom});
		    map.addControl(new BMap.NavigationControl());               
		    map.addControl(new BMap.ScaleControl());                    
		    map.addControl(new BMap.OverviewMapControl());    
		    map.enableScrollWheelZoom(true);                           
		    map.addControl(new BMap.MapTypeControl()); 
		    myGeo = new BMap.Geocoder();	

		    var  mapStyle ={ 
			        features: ["road", "building","water","land"],//隐藏地图上的poi
			        style : "midnight"  //设置地图风格为高端黑
			    }
			//map.setMapStyle(mapStyle);		    
	  }
	  if(city=='中国')
	  {
	    map.centerAndZoom(city,5); 		
	  }
	  else
	  {
      if(level==null)
      {
         level = 11;
      }
			map.centerAndZoom(city,level); 
	  }
  }
  catch(e)
  {
  	map = null;
  }			 
}

// show map text
function showMapText(data)
{
  var aqi,lat,lng,point,marker,icon,label;
  map.clearOverlays();
  for (var i = 0; i < data.length; i++) 
  {
      aqi = data[i].aqi; 
      lat = data[i].latitude;
      lng = data[i].longitude;
      point = new BMap.Point(lng,lat);
      level = getLevel(aqi);
      color = level.color;
      quality = level.quality; 
      var opts = {
        position : point,                     // 指定文本标注所在的地理位置
        offset   : new BMap.Size(-15, -10)    //设置文本偏移量
      }
      var label = new BMap.Label(aqi, opts);  // 创建文本标注对象
      label.setStyle({
         color : "white",
         background: color,
         fontSize : "12px",
         border:'',
         width: "30px",
         textAlign:"center",
         height : "20px",
         lineHeight : "20px",
         fontFamily:"微软雅黑"
      });
      map.addOverlay(label);  
  }
}


// show map
function showMap(map,name,addr,title,desp,city,icon,labelFlag,markerFlag)
{

 	 if(city!='中国')
 	 {
	 	addr = city + addr; 
	 }      	    
	 if(name!=null && addr!=null)
	 {
		var options = {
			onSearchComplete: function(results){
				// 判断状态是否正确
				if (local.getStatus() == BMAP_STATUS_SUCCESS){
					var point = results.getPoi(0).point;
	        		addPoint(name,point,title,desp,icon,labelFlag,markerFlag);
				}
			}
		};
		var local = new BMap.LocalSearch(map, options);
		local.search(addr);		 	   
    }
}

// add point to map 
function addPoint(name,point,title,desp,icon,labelFlag,markerFlag)
{
	//map.centerAndZoom(point, 5);	
    var myIcon = new BMap.Icon(icon, new BMap.Size(23,32));
    var marker = new BMap.Marker(point,{icon:myIcon});
    var label = new BMap.Label(name);
    var len = name.length;
    var offset = new BMap.Size(25, 5);
    label.setOffset(offset);
    if(labelFlag)
    	marker.setLabel(label);
    marker.setTitle(title);
    map.addOverlay(marker);
    var infoWindow = new BMap.InfoWindow(desp);	
    if(markerFlag==true)
	  {
	    marker.addEventListener("mouseover", function () { 
	    	
 				var opts = {
				  width : 385,     // 信息窗口宽度
				  height: 270,     // 信息窗口高度
				  title : "" , // 信息窗口标题
				  enableMessage:false,//设置允许信息窗发送短息
				  message:""
				}
				var infoWindow = new BMap.InfoWindow(desp, opts);  // 创建信息窗口对象 
				map.openInfoWindow(infoWindow,point); //开启信息窗口	
	   });
    }
}

function addPointWithLabel(name,point,title,desp,value,index,labelFlag,markerFlag)
{
  color = getColorByIndex(index);  
  var opts = {
    position : point,    // 指定文本标注所在的地理位置
    offset   : new BMap.Size(-15, -10)    //设置文本偏移量
  }
  var label = new BMap.Label(value, opts);  // 创建文本标注对象
  label.setStyle({
     color : "white",
     background: color,
     fontSize : "13px",
     border:'',
     width: "32px",
     textAlign:"center",
     height : "20px",
     lineHeight : "20px"
   });
   label.setTitle(title);
   map.addOverlay(label); 
   if(markerFlag==true)
   {     
    label.addEventListener("mouseover", function () {   
        var searchInfoWindow = new BMapLib.SearchInfoWindow(map, desp, {
    title  : '<sapn style="font-size:14px">' + name + '</span>',             //标题
    width  : 315,              //宽度
    height : 115,              //高度
    enableAutoPan : true      //自动平移
    });     
    searchInfoWindow.open(point);     
    });
   }  
}

// 获取等级
function getLevelIndex(aqi)
{
    var level;
    if(aqi<=200)
    {
       level = Math.ceil(aqi/50);
       if(level<0)
       {
         level = 1;
       }
    }
    else if(aqi<300)
    {
       level = 5;
    }
    else 
    {
       level = 6;
    }
    return level;
}

// 获取图标
function getIcon(value)
{
  var icon = null;
  if(value<=0){
    icon="resource/img/map/00.png";
	}
	else if(value<=50){
    icon="resource/img/map/01.png";
	}
	else if(value<=100){
		icon="resource/img/map/02.png";
	}
	else if(value<=150){
		icon="resource/img/map/03.png";
	}
	else if(value<=200){
		icon="resource/img/map/04.png";
	}
	else if(value<=300){
		icon="resource/img/map/05.png";
	}
	else{
		icon="resource/img/map/06.png";
	}         
	return icon; 
}

//map.js
function getMap() 
{
   var map_ = new Object();    
   map_.put = function(key, value) {    
       map_[key+'_'] = value;    
   };    
   map_.get = function(key) {    
       return map_[key+'_'];    
   };    
   map_.remove = function(key) {    
       delete map_[key+'_'];    
   };    
   map_.keyset = function() {    
       var ret = "";    
       for(var p in map_) {    
           if(typeof p == 'string' && p.substring(p.length-1) == "_") {    
               ret += ",";    
               ret += p.substring(0,p.length-1);    
           }    
       }    
       if(ret == "") {    
           return ret.split(",");    
       } else {    
           return ret.substring(1).split(",");    
       }    
   };    
   return map_;
}  
