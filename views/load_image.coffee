class @LoadImageDialog
  constructor: ->
    @setLoadImageButton()
    @loadImageStorage()
    @setUtility()

  setLoadImageButton: =>
    $("button#load-image").bind "click", @loadDialog
    $("button#cancel-image").bind "click", @cancelDialog

  setUtility: =>
    $("li.load-player").bind "click", @checkLabel

  loadDialog: ->
    selected_item = $("input:radio:checked").parent("li.load-player")
    player_name = selected_item.find("label").text()
    player_image = selected_item.find("img").attr("src")

    player_data =
      name: player_name
      src: player_image

    window.returnValue = player_data
    window.close()

  cancelDialog: ->
    window.close()

  checkLabel: ->
    target_radio = $(this).find("input:radio")
    checked =  target_radio.attr("checked")
    target_radio.attr("checked", not(checked))

  loadImageStorage: =>
    end_index = localStorage.length - 1
    for i in [0..end_index]
      player_name = localStorage.key(i)
      player_image_src = localStorage[player_name]

      player_list_tag = createPlayerImageTag(player_name, player_image_src)

      $("ul#load-players").append(player_list_tag)


createPlayerImageTag = (name, image_src) ->
  """
  <li class="load-player">
    <input type="radio" name="select_image">
    <label>#{name}</label>
    <img class="player-image" src="#{image_src}" width="50px" height="50px">
  </li>
  """

