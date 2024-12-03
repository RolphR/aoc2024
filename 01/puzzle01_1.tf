locals {
  puzzle1_input = csvdecode("list1,list2\n${replace(file("input.txt"), "/ +/", ",")}")
  puzzle1_list1 = sort([
    for item in local.puzzle1_input :
    item.list1
  ])
  puzzle1_list2 = sort([
    for item in local.puzzle1_input :
    item.list2
  ])
  puzzle1_distances = [
    for item1, item2 in zipmap(local.puzzle1_list1, local.puzzle1_list2) :
    abs(item1 - item2)
  ]
  puzzle1_solution = sum(local.puzzle1_distances)
}

output "puzzle1" {
  value = local.puzzle1_solution
  precondition {
    condition     = local.puzzle1_solution == 2113135
    error_message = "Invalid result"
  }
}
