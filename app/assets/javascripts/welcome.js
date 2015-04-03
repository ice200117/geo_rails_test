$(document).on("page:change", function() {
  var page;
  page = $("body").attr("class");
  $(".nav li").removeClass("active");
  return $("#"+page).addClass("active");
});
