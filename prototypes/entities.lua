data:extend({
  {
    type = "explosion",
    name = "deltic-start",
    flags = {"not-on-map"},
    animations =
    {
      {
        filename = "__core__/graphics/empty.png",
        priority = "low",
        width = 1,
        height = 1,
        frame_count = 1,
        line_length = 1,
        animation_speed = 1
      },
    },
    light = {intensity = 0, size = 0},
    sound =
    {
      {
      filename = "__DelticHonk__/sounds/Deltic1.ogg",
      volume = SINGLE_HONK_VOLUME
      }
    }
  },
  {
    type = "explosion",
    name = "deltic-stop",
    flags = {"not-on-map"},
    animations =
    {
      {
        filename = "__core__/graphics/empty.png",
        priority = "low",
        width = 1,
        height = 1,
        frame_count = 1,
        line_length = 1,
        animation_speed = 1
      },
    },
    light = {intensity = 0, size = 0},
    sound =
    {
      {
      filename = "__DelticHonk__/sounds/Deltic1R.ogg",
      volume = DOUBLE_HONK_VOLUME
      }
    }
  }
})