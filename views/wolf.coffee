class @ManageWolf
  constructor: ->
    @member_count = $("ul.player-list li.player").size()
    @dead_count = 0

    @onloadSettings()

    @setImageZoomEvent()
    @setResetVote()
    @setVoteResult()

    @setKillButtons()
    @setDateOperators()
    @setVote()
    @setCancelVote()

    @setAddRole()
    @setEditRole()

    # NOTE: モーダルを消す動作は最後に動作させる
    @setButtons()
    @setMask()

    @mask_remain = false

  onloadSettings: ->
    @reloadMemberCount()

  setImageZoomEvent: ->
    $("li.player").bind "click", @zoomImage

  setVoteResult: ->
    $("div.sidebar-operations button#vote-result").bind "click", @voteResult

  setResetVote: ->
    $("div.sidebar-operations button#reset-vote").bind "click", @resetVote

  setKillButtons: ->
    $("button.kill-button").bind "click", @killPlayer
    $("button#kill-cancel").bind "click", @killCancel

  setDateOperators: ->
    $("span.date-up").bind "click", @dateUp
    $("span.date-down").bind "click", @dateDown

  setVote: ->
    $("#modal button#vote").bind "click", @voteToPlayer

  setCancelVote: ->
    $("#modal button#vote-cancel").bind "click", @cancelVote

  setAddRole: ->
    $("button#add-role").bind "click", @addRole

  setEditRole: ->
    $("li.role label.edit-role").bind "click", @editRole
    $("li.role label.remove-role").bind "click", @removeRole
    $("li.role label.finish-edit").bind "click", @finishEdit

  setMask: ->
    $("#mask").bind "click", @hidePhoto
    $("#modal div.modal-name span.close").bind "click", @hidePhoto

  setButtons: ->
    $("#modal button").bind "click", @hidePhoto
    $("#modal button").bind "click", @reloadMemberCount
    $("span.date-up").bind "click", @reloadMemberCount
    $("span.date-down").bind "click", @reloadMemberCount

  reloadMemberCount: =>
    $("span#total").text(convertHalfToAll(@member_count))
    @dead_count = $("ul.player-list li.player img.kill-image").size()
    $("span#dead").text(convertHalfToAll(@dead_count))
    $("span#rest").text(convertHalfToAll(@member_count - @dead_count))

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
    createKillImage = (kill_class, path) ->
      $("<img class=\"kill-image #{kill_class}\" src=\"#{path}\" width=\"128\" height=\"128\">")

    id = $("input#modal-id").attr("value")
    # NOTE: this = kill-button
    kill_button_id = $(this).attr("id")
    kill_image = switch kill_button_id
      when "day-kill-button"
        createKillImage("day-kill", "/images/day-kill.png")
      when "night-kill-button"
        createKillImage("night-kill", "/images/night-kill.png")

    # NOTE: player image change color to gray
    window.changeImage(id.replace(/-/, "-img-"))

    player_list = $("li##{id}")
    player_list.addClass "kill-player"
    player_list.find("img").remove("img.kill-image")
    player_list.append(kill_image)

    killed_day = "<span class=\"killed-day\">#{$("span.day-number").text()}日目 死亡　</span>"
    kill_image.after killed_day

  killCancel: ->
    player_id = $("input#modal-id").attr("value")

    # NOTE: player image restore original color
    window.reviveImage(player_id.replace(/-/, "-img-"))

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

  cancelVote: ->
    player_id = $("input#modal-id").attr("value")
    $("li##{player_id} p.player-vote").remove("p.player-vote")

  voteResult: ->
    vote_list = $("ul.player-list p.player-vote")
    if vote_list.size() is 0
      alert("投票してから押してね")
      return false

    before_vote = $(vote_list[0])
    for vote in vote_list when parseInt($(vote).text()) > parseInt(before_vote.text())
      before_vote = $(vote)
    before_vote.parent("li.player").trigger "click"

  resetVote: ->
    $("ul.player-list li.player p").remove("p.player-vote")

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

  addRole: =>
    createRoleHtml = (name) ->
      "<li class=\"role\">\
        <label class=\"role-name\">#{name}</label>\
        <label class=\"role-number\">&nbsp;0</label>\
        <label class=\"edit-role\">編集</label>\
        <label class=\"remove-role\">削除</label>\
        <input type=\"text\" class=\"role-name hide\">\
        <input type=\"number\" class=\"role-number hide\" min=\"0\">\
        <label class=\"finish-edit hide\">完了</label>\
       </li>"

    role_name = prompt("役職名")
    return null unless role_name?

    role_html = createRoleHtml(role_name)
    $("ul.role-list li.add-role").before(role_html)

    $("li.role label.edit-role").unbind "click"
    $("li.role label.remove-role").unbind "click"
    $("li.role label.finish-edit").unbind "click"
    $("li.role label.edit-role").bind "click", @editRole
    $("li.role label.romove-role").bind "click", @removeRole
    $("li.role label.finish-edit").bind "click", @finishEdit

  editRole: ->
    role_row = $(this).parent("li.role")
    role_row.find(".hide").removeClass "hide"
    role_row.find("label.role-name").addClass "hide"
    role_row.find("label.role-number").addClass "hide"
    role_row.find("label.edit-role").addClass "hide"
    role_row.find("label.remove-role").addClass "hide"

    role_name = role_row.find("label.role-name").text()
    role_number = role_row.find("label.role-number").text()
    role_number = parseInt(role_number)
    role_row.find("input.role-name").val(role_name)
    role_row.find("input.role-number").val(role_number)

  removeRole: ->
    $(this).parent("li.role").remove("li.role")

  finishEdit: ->
    role_row = $(this).parent("li.role")

    role_number = role_row.find("input.role-number").val()
    unless isNumber(role_number)
      alert "人数は数字を入れてね。"
      return false

    if role_number.length is 1
      role_number = "&nbsp;" + role_number.toString()
    role_row.find("label.role-number").html(role_number)
    role_row.find("label.role-name").text(role_row.find("input.role-name").val())

    role_row.find(".hide").removeClass "hide"
    role_row.find("input").addClass "hide"
    role_row.find("label.finish-edit").addClass "hide"

  hidePhoto: =>
    if @mask_remain
      @mask_remain = false
      return false

    $("#mask").addClass "hide"
    $("#modal").addClass "hide"

isNumber = (value) ->
  not(isNaN(value))


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

h = (value) ->
  $("<div/>").text(value).html()
