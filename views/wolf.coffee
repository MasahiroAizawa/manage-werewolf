class @ManageWolf
  constructor: ->
    @setImageZoomEvent()
    @setMask()

  setImageZoomEvent: ->
    $("li").bind "click", @zoomImage

  zoomImage: (event) ->
    url = $(this).find("img").attr("src")
    name = $(this).find("span").text()

    setModalImage = (name, url) ->
      modal = $("#modal")
      modal.find("div.modal-name span.player-name").text(name)
      modal.find("div.modal-image img").attr("src", url)
      modal

    modal = setModalImage(name, url)
    modal.removeClass "hide"
    $("#mask").removeClass "hide"

  setMask: ->
    $("#mask").bind "click", @hidePhoto
    $("#modal div.modal-name span.close").bind "click", @hidePhoto

  hidePhoto: ->
    $("#mask").addClass "hide"
    $("#modal").addClass "hide"




