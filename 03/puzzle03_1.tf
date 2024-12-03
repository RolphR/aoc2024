locals {
  puzzle1_mul_statements = regexall("mul[(][0-9]+,[0-9]+[)]", file("input.txt"))
  puzzle1_mul_values = [
    for statement in local.puzzle1_mul_statements :
    regexall("[0-9]+", statement)
  ]
  puzzle1_solution = sum([
    for value in local.puzzle1_mul_values :
    value[0] * value[1]
  ])
}

output "puzzle1" {
  value = local.puzzle1_solution
  precondition {
    condition     = local.puzzle1_solution == 173529487
    error_message = "Invalid result"
  }
}
