class @LoadImageDialog
  constructor: ->
    @setLoadImageButton()
    @setDeletePlayer()

    @loadImageStorage()
    # NOTE: call after loadImageStorage
    @setUtility()


  setLoadImageButton: =>
    $("button#load-image").bind "click", @loadDialog
    $("button#cancel-image").bind "click", @cancelDialog

  setUtility: =>
    $("div#load-modal li.load-player").bind "click", @checkLabel

  setDeletePlayer: =>
    $("button#delete-image").bind "click", @deleteImage

  loadDialog: ->
    selected_item = $("div#load-modal input:radio:checked").parent("li.load-player")
    player_name = selected_item.find("label").text()
    player_image = selected_item.find("img").attr("src")

    player_data =
      name: player_name
      src: player_image

    setReturnPlayer(player_data)
    close()

  cancelDialog: ->
    close()

  checkLabel: ->
    target_radio = $(this).find("input:radio")
    checked =  target_radio.attr("checked")
    target_radio.attr("checked", not(checked))

  deleteImage: ->
    selected_item = $("div#load-modal input:radio:checked").parent("li.load-player")
    return alert_tag "削除対象を選択してください。" unless selected_item?

    key_name = selected_item.find("label").text()

    localStorage.removeItem(key_name)
    selected_item.remove()

  loadImageStorage: =>
    end_index = localStorage.length - 1
    for i in [0..end_index]
      player_name = localStorage.key(i)
      player_image_src = localStorage[player_name]

      player_list_tag = createPlayerImageTag(player_name, player_image_src)

      $("ul#load-players").append(player_list_tag)

    mode = getMode()

    load_button = $("button#load-image")
    delete_button = $("button#delete-image")

    if mode is "list"
      load_button.addClass "hide"
      delete_button.removeClass "hide"
    else if mode is "load"
      delete_button.addClass "hide"
      load_button.removeClass "hide"
    else
      delete_button.addClass "hide"
      load_button.addClass "hide"


createPlayerImageTag = (name, image_src) ->
  """
  <li class="load-player">
    <input type="radio" name="select_image">
    <label>#{name}</label>
    <img class="player-image" src="#{image_src}" width="50px" height="50px">
  </li>
  """

alert_tag = (msg) ->
  tag = """
  <span class="message">#{msg}</span>
  """
  $("div#content span.message").remove("span.message")
  $("div#content ul#load-players").before(tag)


getMode = ->
  window?.dialogArguments?[0]

setReturnPlayer = (player_data) ->
  window.returnValue = player_data

close = ->
  window.close()

