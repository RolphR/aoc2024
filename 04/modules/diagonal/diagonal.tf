variable "lines" {
  type = list(string)
}

locals {
  # This module only produces diagonals form top left to bottom right
  # string reverse the lines to produce top right to bottom left
  diagonals = flatten([
    # all diagonal lines starting top-left, going to the right
    [
      for col in range(0, length(var.lines[0])) :
      join("", [
        for row in range(0, length(var.lines)) :
        substr(var.lines[row], col + row, 1)
        if col + row < length(var.lines[0])
      ])
    ],
    # all diagonal lines starting 1 line below top left, going down
    [
      for row in range(1, length(var.lines)) :
      join("", [
        for col in range(0, length(var.lines[0])) :
        substr(var.lines[col + row], col, 1)
        if col + row < length(var.lines)
      ])
    ],
  ])
}

output "lines" {
  value = local.diagonals
}
