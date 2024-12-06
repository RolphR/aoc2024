locals {
  puzzle1_horizontal_lines = [
    for line in split("\n", file("input.txt")) :
    line
    if line != ""
  ]
  puzzle1_vertical_lines = [
    for col in range(0, length(local.puzzle1_horizontal_lines[0])) :
    join("", [
      for row in range(0, length(local.puzzle1_horizontal_lines)) :
      substr(local.puzzle1_horizontal_lines[row], col, 1)
    ])
  ]
}

module "top_left_bottom_right" {
  source = "./modules/diagonal"
  lines  = local.puzzle1_horizontal_lines
}

module "top_right_bottom_left" {
  source = "./modules/diagonal"
  lines = [
    for line in local.puzzle1_horizontal_lines :
    strrev(line)
  ]
}

locals {
  puzzle1_all_lines = flatten([
    local.puzzle1_horizontal_lines,
    local.puzzle1_vertical_lines,
    module.top_left_bottom_right.lines,
    module.top_right_bottom_left.lines,
  ])
  puzzle1_words = flatten([
    for line in local.puzzle1_all_lines :
    flatten([
      for c in range(0, length(line) - 3) :
      [
        substr(line, c, 4),
        substr(strrev(line), c, 4)
      ]
    ])
  ])
  puzzle1_solution = length([
    for word in local.puzzle1_words :
    word
    if anytrue([
      word == "XMAS",
    ])
  ])
}

output "puzzle1" {
  value = local.puzzle1_solution
  precondition {
    condition     = local.puzzle1_solution == 2549
    error_message = "Invalid result"
  }
}
