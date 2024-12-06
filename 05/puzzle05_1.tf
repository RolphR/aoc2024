locals {
  puzzle1_input_sections = split("\n\n", file("input.txt"))
  puzzle1_input_ordering = [
    for line in split("\n", local.puzzle1_input_sections[0]) :
    split("|", line)
    if line != ""
  ]
  puzzle1_input_update_lines = [
    for line in split("\n", local.puzzle1_input_sections[1]) :
    split(",", line)
    if line != ""
  ]
  puzzle1_input_updates = zipmap(range(0, length(local.puzzle1_input_update_lines)), local.puzzle1_input_update_lines)
}

module "evaluate_update" {
  for_each  = local.puzzle1_input_updates
  source    = "./modules/evaluate_update"
  update    = each.value
  orderings = local.puzzle1_input_ordering
}

locals {
  puzzle1_solution = sum([
    for key, update in module.evaluate_update :
    update.center_value
  ])
}

output "puzzle1" {
  value = local.puzzle1_solution
  precondition {
    condition     = local.puzzle1_solution == 5091
    error_message = "Invalid result"
  }
}
