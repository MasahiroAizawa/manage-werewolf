class @ManageWolf
  constructor: ->
    @setImageZoomEvent()
    @setMask()
    @setKillButtons()

  setImageZoomEvent: ->
    $("li").bind "click", @zoomImage

  setKillButtons: ->
    $("button.kill-button").bind "click", @killPlayer
    $("button.kill-button").bind "click", @hidePhoto

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
    createKillImage = (kill_class, file) ->
      $("<img class=\"kill-image #{kill_class}\" src=\"/images/#{file}\" width=\"128\" height=\"128\">")

    id = $("input#modal-id").attr("value")
    # this = kill-button
    kill_button_id = $(this).attr("id")
    kill_image = switch kill_button_id
      when "day-kill-button"
        createKillImage("day-kill", "day-kill.png")
      when "night-kill-button"
        createKillImage("night-kill", "night-kill.png")

    player_list = $("li##{id}")
    player_list.addClass "kill-player"
    player_list.remove("img.kill-image")
    player_list.append(kill_image)

  hidePhoto: ->
    $("#mask").addClass "hide"
    $("#modal").addClass "hide"





