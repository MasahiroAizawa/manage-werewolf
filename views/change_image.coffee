window.changeImage = (image_id) ->
  target_image = document.getElementById(image_id)
  target_image.dataset.src = target_image.src

  canvas = document.createElement("canvas")
  canvas_context = canvas.getContext("2d")

  image_width = target_image.width
  image_height = target_image.height

  canvas.width = image_width
  canvas.height = image_height

  canvas_context.drawImage(target_image, 0, 0, image_width, image_height)
  image_data = canvas_context.getImageData(0, 0, image_width, image_height)

  image_data_length = image_width * image_height * 4

  for i in [0..image_data_length] by 4
    red = image_data.data[i]
    green = image_data.data[i + 1]
    blue = image_data.data[i + 2]

    continue unless red? or green? or blue?

    gray = (red + green + blue) / 3

    image_data.data[i] = gray
    image_data.data[i + 1] = gray
    image_data.data[i + 2] = gray

  canvas_context.putImageData(image_data, 0, 0, 0, 0, image_width, image_height)

  document.getElementById(image_id).src = canvas.toDataURL()


window.reviveImage = (image_id) ->
  target_image = document.getElementById(image_id)
  document.getElementById(image_id).src = target_image.dataset.src
