class @ManageWolf
  constructor: ->
    @setImageZoomEvent()
    @setKillButtons()
    @setDateOperators()
    @setVote()
    @setMask()
    # NOTE: モーダルを消す動作は最後に動作させる
    @setButtons()

    @mask_remain = false

  setImageZoomEvent: ->
    $("li").bind "click", @zoomImage

  setKillButtons: ->
    $("button.kill-button").bind "click", @killPlayer
    $("button#kill-cancel").bind "click", @killCancel

  setDateOperators: ->
    $("span.date-up").bind "click", @dateUp
    $("span.date-down").bind "click", @dateDown

  setVote: ->
    $("#modal button#vote").bind "click", @voteToPlayer

  setMask: ->
    $("#mask").bind "click", @hidePhoto
    $("#modal div.modal-name span.close").bind "click", @hidePhoto

  setButtons: ->
    $("#modal button").bind "click", @hidePhoto

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
    # NOTE: this = kill-button
    kill_button_id = $(this).attr("id")
    kill_image = switch kill_button_id
      when "day-kill-button"
        createKillImage("day-kill", "day-kill.png")
      when "night-kill-button"
        createKillImage("night-kill", "night-kill.png")

    player_list = $("li##{id}")
    player_list.addClass "kill-player"
    player_list.find("img").remove("img.kill-image")
    player_list.append(kill_image)

    killed_day = "<span class=\"killed-day\">#{$("span.day-number").text()}日目 死亡　</span>"
    kill_image.after killed_day

  killCancel: ->
    player_id = $("input#modal-id").attr("value")

    player_list = $("li##{player_id}")
    player_list.find("img").remove("img.kill-image")
    player_list.find("span.killed-day").remove("span.killed-day")
    player_list.removeClass "kill-player"

  voteToPlayer: =>
    createVoteNumberHtml = (number) ->
      if number.toString().length is 1
        number = "&nbsp;" + number.toString()
      "<p class=\"player-vote\">#{number}</p>"

    vote_number = $("#modal input.vote-number").val()

    if not(isNumber(vote_number)) or parseInt(vote_number) is 0
      alert("プレイヤーへの投票数を入力してください")
      @mask_remain = true
      return false
    @mask_remain = false

    vote_number_html = createVoteNumberHtml(vote_number)

    player_id = $("input#modal-id").attr("value")
    player_list = $("li##{player_id}")
    player_list.remove("p.player-vote")
    player_list.append(vote_number_html)

    $("#modal input.vote-number").val("0")

  dateUp: ->
    day = $("span.day-number").text()
    day_number = parseInt convertAllToHalf(day)
    day_number++
    $("span.day-number").text convertHalfToAll(day_number)

  dateDown: ->
    day = $("span.day-number").text()
    day_number = convertAllToHalf(day)
    return if day_number <= 0
    day_number--
    $("span.day-number").text convertHalfToAll(day_number)

  hidePhoto: =>
    if @mask_remain
      @mask_remain = false
      return false

    $("#mask").addClass "hide"
    $("#modal").addClass "hide"

isNumber = (value) ->
  # TODO: Implement validation
  true


convertAllToHalf = (number_string) ->
  number_string = number_string.replace(/１/g, "1")
  number_string = number_string.replace(/２/g, "2")
  number_string = number_string.replace(/３/g, "3")
  number_string = number_string.replace(/４/g, "4")
  number_string = number_string.replace(/５/g, "5")
  number_string = number_string.replace(/６/g, "6")
  number_string = number_string.replace(/７/g, "7")
  number_string = number_string.replace(/８/g, "8")
  number_string = number_string.replace(/９/g, "9")
  number_string = number_string.replace(/０/g, "0")

  parseInt number_string

convertHalfToAll = (number) ->
  number_string = number.toString()
  number_string = number_string.replace(/1/g, "１")
  number_string = number_string.replace(/2/g, "２")
  number_string = number_string.replace(/3/g, "３")
  number_string = number_string.replace(/4/g, "４")
  number_string = number_string.replace(/5/g, "５")
  number_string = number_string.replace(/6/g, "６")
  number_string = number_string.replace(/7/g, "７")
  number_string = number_string.replace(/8/g, "８")
  number_string = number_string.replace(/9/g, "９")
  number_string = number_string.replace(/0/g, "０")

  number_string = "　" + number_string if number_string.length is 1

  number_string


