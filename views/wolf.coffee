class @ManageWolf
  constructor: ->

  setImageZoomEvent: ->
    $("li").bind "click", @zoomImage

  zoomImage: ->
    url = $(this).find("img").attr("src")

    # TODO: create modal html
    add_html = "<img src=\"#{url}\">"

    # TODO: show modal html

    # test code
    $("ul").before(add_html)


