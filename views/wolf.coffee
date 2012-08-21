class @ManageWolf
  constructor: ->

  setImageZoomEvent: ->
    $("li").bind "click", @zoomImage

  zoomImage: (event) ->
    url = $(this).find("img").attr("src")
    name = $(this).find("span").text()

    setModalImage = (name, url) ->
      modal = $("#modal")
      modal.find("div.modal-name h3").text(name)
      modal.find("div.modal-image img").attr("src", url)
      modal

    modal = setModalImage(name, url)
    modal.removeClass "hide"



