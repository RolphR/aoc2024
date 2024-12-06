variable "map" {
  type = list(string)
}

locals {
  guard_location = flatten([
    for row in range(0, length(var.map)) :
    [
      row,
      # -1 for element to index
      try(length(regexall("^[.#X]+[<>^v]", var.map[row])[0]) - 1, 0)
    ]
    if length(regexall("^[.#X]+[<>^v]", var.map[row])) > 0
  ])
  guard_character = substr(var.map[local.guard_location[0]], local.guard_location[1], 1)

  # Calculate target location
  target_location = lookup({
    "^" = [
      local.guard_location[0] - 1,
      local.guard_location[1],
    ]
    "v" = [
      local.guard_location[0] + 1,
      local.guard_location[1],
    ]
    "<" = [
      local.guard_location[0],
      local.guard_location[1] - 1,
    ]
    ">" = [
      local.guard_location[0],
      local.guard_location[1] + 1,
    ]
  }, local.guard_character)
  # E for Exit
  target_character = try(substr(var.map[local.target_location[0]], local.target_location[1], 1), "E")

  # Simulate turn right
  turn_right_character = lookup({
    "^" = ">"
    ">" = "v"
    "v" = "<"
    "<" = "^"
  }, local.guard_character)
  map_turn_right = [
    for row in range(0, length(var.map)) :
    row == local.guard_location[0] ? join(local.turn_right_character, split(local.guard_character, var.map[row])) : var.map[row]
  ]

  # Simulate move forward
  map_mark_visited = [
    for row in range(0, length(var.map)) :
    row == local.guard_location[0] ? join("X", split(local.guard_character, var.map[row])) : var.map[row]
  ]
  map_move_forward = local.target_character == "E" ? var.map : [
    for row in range(0, length(var.map)) :
    row == local.target_location[0] ? join("", [
      substr(local.map_mark_visited[row], 0, local.target_location[1]),
      local.guard_character,
      substr(local.map_mark_visited[row], local.target_location[1] + 1, -1),
    ]) : local.map_mark_visited[row]
  ]

  new_map = lookup({
    "E" = var.map # Done!
    "#" = local.map_turn_right
    "." = local.map_move_forward
    "X" = local.map_move_forward
  }, local.target_character)
}

# Enable for binary counting terraform init
/*
module "move1" {
  source = "./"
  map    = local.new_map
}

module "move2" {
  source = "./"
  map    = module.move1.map
}
*/

output "debug" {
  value = {
    guard_location   = local.guard_location
    guard_heading    = local.guard_character
    target_location  = local.target_location
    target_character = local.target_character
  }
}

output "map" {
  value = local.new_map
}

output "finished" {
  value = local.target_character == "E"
}
