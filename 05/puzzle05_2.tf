locals {
  puzzle2_solution = sum([
    for key, update in module.evaluate_update :
    update.corrected_center_value
  ])
}

output "puzzle2" {
  value = local.puzzle2_solution
  precondition {
    condition     = local.puzzle2_solution == 4681
    error_message = "Invalid result"
  }
}
