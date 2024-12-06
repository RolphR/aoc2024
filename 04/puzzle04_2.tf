locals {
  puzzle2_line_groups = {
    for row in range(1, length(local.puzzle1_horizontal_lines) - 1) :
    "center_line_${row}" => [
      local.puzzle1_horizontal_lines[row - 1],
      local.puzzle1_horizontal_lines[row],
      local.puzzle1_horizontal_lines[row + 1],
    ]
  }
}

module "find_mas_crosses" {
  for_each = local.puzzle2_line_groups
  source   = "./modules/find_mas_crosses"
  lines    = each.value
}

locals {
  puzzle2_solution = sum([
    for x in module.find_mas_crosses :
    x.count
  ])
}

output "puzzle2" {
  value = local.puzzle2_solution
  precondition {
    condition     = local.puzzle2_solution == 2003
    error_message = "Invalid result"
  }
}
