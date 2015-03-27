$(document).on "page:change", ->

  page = $("body").attr("class")
  $(".nav li").removeClass("active")
  $("#"+page).addClass("active")
  
  paintIt = (element, backgroundColor, textColor) ->
    element.style.backgroundColor = backgroundColor
    if textColor?
      element.style.color = textColor

  $ ->
    $("a[data-background-color]").click ->
      backgroundColor = $(this).data("background-color")
      textColor = $(this).data("text-color")
      paintIt(this, backgroundColor, textColor)


  ch = (id, ih) ->
    id.innerHTML = ih

  $ ->
    $("h1[data-ih]").click ->
      ih = $(this).data("ih")
      ch(this, ih)
