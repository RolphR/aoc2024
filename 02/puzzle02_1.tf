locals {
  puzzle1_reports = [
    for line in split("\n", file("input.txt")) :
    regexall("[0-9]+", line)
    if line != ""
  ]
  puzzle1_level_changes = [
    for report in local.puzzle1_reports :
    [
      for i in range(0, length(report) - 1) :
      element(report, (i)) - element(report, i + 1)
    ]
  ]
  puzzle1_solution = length([
    for changes in local.puzzle1_level_changes :
    changes
    if anytrue([
      alltrue([for c in changes : -3 <= c && c <= -1]),
      alltrue([for c in changes : 1 <= c && c <= 3]),
    ])
  ])
}

output "puzzle1" {
  value = local.puzzle1_solution
  precondition {
    condition     = local.puzzle1_solution == 246
    error_message = "Invalid result"
  }
}
