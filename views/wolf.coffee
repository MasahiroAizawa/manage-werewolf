class @ManageWolf
  constructor: ->
    @setImageZoomEvent()
    @setMask()
    @setKillButton()

  setImageZoomEvent: ->
    $("li").bind "click", @zoomImage

  setKillButton: ->
    $("button#kill-button").bind "click", @killPlayer
    $("button#kill-button").bind "click", @hidePhoto

  setMask: ->
    $("#mask").bind "click", @hidePhoto
    $("#modal div.modal-name span.close").bind "click", @hidePhoto

  zoomImage: (event) ->
    url = $(this).find("img").attr("src")
    name = $(this).find("span").text()
    id = $(this).attr("id")

    setModalImage = (name, url, id) ->
      modal = $("#modal")
      modal.find("div.modal-name span.player-name").text(name)
      modal.find("div.modal-image img").attr("src", url)
      modal.find("input#modal-id").attr("value", id)
      modal

    modal = setModalImage(name, url, id)
    modal.removeClass "hide"
    $("#mask").removeClass "hide"

  killPlayer: ->
    id = $("input#modal-id").attr("value")
    $("li##{id} span").addClass "kill"

  hidePhoto: ->
    $("#mask").addClass "hide"
    $("#modal").addClass "hide"




