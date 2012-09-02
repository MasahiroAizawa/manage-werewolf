class @ImageUploader
  # NOTE: both args are jQuery object only.
  constructor: (@file_input, @image_div) ->
    @file_input.bind "change", @onChange
    $("html").bind "dragover", @onCancel
    $("html").bind "dragenter", @onCancel
    $("html").bind "drop", @onCancel
    @image_div.bind "drop", @onDropFile

  onChange: =>
    file = event.target.files[0]
    @readFile(file)

  readFile: (file) ->
    file_type = file.type

    reader = new FileReader()
    reader.onload = @applyImageFile

    reader.readAsDataURL(file)

  onCancel: ->
    if event.preventDefault
      event.preventDefault()
    return false

  onDropFile: =>
    event.preventDefault()

    file = event.dataTransfer.files[0]
    @readFile(file)

  applyImageFile: =>
    data_url = event.target.result
    image_tag = createFileImageTag(data_url)

    @image_div.find("img#player-image").remove()
    @image_div.find("div.drag-drop-area").remove()

    @image_div.append(image_tag)

createFileImageTag = (data) ->
  "<img id=\"player-image\" width=\"256px\" height=\"256px\" src=\"#{data}\" >"

