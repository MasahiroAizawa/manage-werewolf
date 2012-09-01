class @ImageUploader
  # NOTE: both args are jQuery object only.
  constructor: (@file_input, @image_div) ->
    @file_input.bind "change", @readFile

  readFile: =>
    file = event.target.files[0]
    file_type = file.type

    reader = new FileReader()
    reader.onload = @applyImageFile

    reader.readAsDataURL(file)

  applyImageFile: =>
    data_url = event.target.result
    image_tag = createFileImageTag(data_url)

    @image_div.find("img#player-image").remove()
    @image_div.find("div.drag-drop-area").remove()

    @image_div.append(image_tag)

createFileImageTag = (data) ->
  "<img id=\"player-image\" width=\"256px\" height=\"256px\" src=\"#{data}\" >"

