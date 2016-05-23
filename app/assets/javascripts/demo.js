//openAppDownFunc

function openAppDownFunc(o){
    var obj = $(o);
    var item_close = obj.find('.item1');
    var item_open = obj.find('.item2');
    $(item_close).on('click', clickFunc1);

    function clickFunc1(){
        $(item_close).hide("fast", function(){
            $(item_open).show("fast", function(){
                $(item_open).focus();
                $(item_close).hideFocus="true";
                $(item_open).on('blur', clickFunc2);
            });
        });
    }
    function clickFunc2(){
        $(item_close).show("slow");
        $(item_open).hide("slow");
    }
}

function init(){
    var gd = 17;
    //console.log("gd:"+gd);
    if(!-[1,]){
        gd = 21;
    }
    $('.lf-head-banner').css('width',window.screen.width-gd);
    $('.lf-head-kanban').css('margin-left',(window.screen.width-1098)/2);
    $('.lf-menu-c').css('margin-left',(window.screen.width-1098)/2);
    $('.lf-menu').css('width',window.screen.width-gd);
    $('.lf-content').css('margin-left',(window.screen.width-1100)/2);
    $('.lf-content-bottom-info').css('margin-left',(window.screen.width-1098)/2);
    $('.lf-bottom').css('width',window.screen.width-gd);
    $('.lf-bottom-c').css('margin-left',(window.screen.width-1100)/2);
    $('.download').css('left',(window.screen.width-260));
}

function appMove(){
    $(window).resize(function () {
       // var total = window.screen.width;
        //var top = $('.download').offset().top;
        var width =  document.body.clientWidth;
        $('.download').css('left',(width-220));
    });
}

/* // 点击下拉
function clickDown(children,followItem){
    $.each(children,function(index,value){
        $(value).on('click',function(){
            $(this).children().addClass('cur');
            $(this).siblings().children().removeClass('cur');
            if($(this).hasClass('pClick')){
                var width = $('.pClick').width();
                var left = $('.pClick').prev().width();
                var top = $('.pClick').height();
                if($(followItem).css('display')=='none'){
                    $(followItem).css({
                        'width':width,
                        'left':left,
                        'top':top
                    });
                    $(this).find('span').css('background','url("../langfang/images/qp1.png")no-repeat right center');
                    $(followItem).fadeIn();
                }
                else{
                    $(followItem).fadeOut();
                    $(this).find('span').css('background','url("../langfang/images/icon.gif")no-repeat right center');
                }
            }
            else{
                $('.lf-menu-split').fadeOut();
                $('.pClick').find('span').css('background','url("../langfang/images/icon.gif")no-repeat right center');
            }
        });
    });
}*/

function hoverList(children,followItem){
    $.each(children,function(index,value){
        $(value).hover(function(){
            if($(value).hasClass('pClick')){
                var width = $('.pClick').width();
                var left = $('.pClick').prev().width();
                var top = $('.pClick').height();
                if($(followItem).css('display')=='none'){
                    $(followItem).css({
                        'width':width,
                        'margin-left':0,
                        'margin-top':0
                    });
                    $(value).find('span').removeClass('down').addClass('up');
                    $(followItem).fadeIn('slow');
                }
            }
        },function(){
            $(followItem).fadeOut('slow');
            $(value).find('span').removeClass('up').addClass('down');
        });

    });
    $.each(children,function(index,value){
        $(value).on('click',function(){
            //console.log('this index....'+index);
            $(value).children('a').addClass('cur');
            $(value).siblings().children('a').removeClass('cur');
        });
    });
}

function clickItem(pNode,item,styleNode){
    $.each(item,function(index,value){
        $(value).on('click',function(){
            $(pNode).fadeOut('slow');
            $(styleNode).find('span').removeClass('up').addClass('down');
            $(styleNode).children('a').addClass('cur');
            $(styleNode).siblings().children('a').removeClass('cur');
        });
    });
}

function hoverDown(){
    var item = $('.area-data > .area-data-content').find('.area-data-head');
    var cItem = item.find('.float');
    $.each(item,function(index,value){
        $(value).hover(function(){
            $(cItem).css('display','none');
            $(cItem).eq(index).fadeIn().focus();
        },function(){
            $(cItem).eq(index).css('display','none');
        });
    });
}

function hoverTab(){
    var item = $('.lf-tab > ul').children('li');
    $.each(item,function(index,value){
        $(value).on('mouseover',function(){
            if($(value).children('a').hasChildNodes){
            }
            else{
                $(value).find('a').append('<i></i>');
            }
        });
        $(value).on('mouseout',function(){
            $(value).children('a').find('i').remove();
            $(value).find('.cur').append('<i></i>');
        });
    });

}

(function($){
})(jQuery);