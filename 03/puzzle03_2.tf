locals {
  puzzle2_statements = [
    for statement in regexall("(mul[(][0-9]+,[0-9]+[)])|(do[(][)])|(don't[(][)])", file("input.txt")) :
    compact(statement)[0]
  ]
  puzzle2_filtered_input = join("", local.puzzle2_statements)
  puzzle2_enabled_input = join("", flatten([
    # First part is always enabled
    regexall("^(?:(?:mul[(][0-9]+,[0-9]+[)])|(?:do[(][)]))*(?:don't[(][)])", local.puzzle2_filtered_input),
    # Last part may not end with a don't()
    regexall("(?:do[(][)])(?:(?:mul[(][0-9]+,[0-9]+[)])|(?:do[(][)]))*(?:don't[(][)])?", local.puzzle2_filtered_input),
  ]))
  puzzle2_mul_statements = regexall("mul[(][0-9]+,[0-9]+[)]", local.puzzle2_enabled_input)
  puzzle2_mul_values = [
    for statement in local.puzzle2_mul_statements :
    regexall("[0-9]+", statement)
  ]
  puzzle2_solution = sum([
    for value in local.puzzle2_mul_values :
    value[0] * value[1]
  ])
}

output "puzzle2" {
  value = local.puzzle2_solution
  precondition {
    condition     = local.puzzle2_solution == 99532691
    error_message = "Invalid result"
  }
}
