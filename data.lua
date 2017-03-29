SINGLE_HONK_VOLUME = 1.2
DOUBLE_HONK_VOLUME = 1.2

require("prototypes.entities")

data:extend({
  {
    type = "custom-input",
    name = "honk",
    key_sequence = "H"
  },
  {
    type = "custom-input",
    name = "toggle-train-control",
    key_sequence = "J"
  }
})