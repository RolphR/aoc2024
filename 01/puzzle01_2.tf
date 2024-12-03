locals {
  puzzle2_similarities = [
    for item1 in local.puzzle1_list1 :
    item1 * length([
      for item2 in local.puzzle1_list2 :
      item2
      if item1 == item2
    ])
  ]
  puzzle2_solution = sum(local.puzzle2_similarities)
}

output "puzzle2" {
  value = local.puzzle2_solution
  precondition {
    condition     = local.puzzle2_solution == 19097157
    error_message = "Invalid result"
  }
}
