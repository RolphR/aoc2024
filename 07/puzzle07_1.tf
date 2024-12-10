variable "line" {
  type    = string
  default = ""
}
locals {
  puzzle1_lines = var.line != "" ? [var.line] : [
    for line in split("\n", file("input1.txt")) :
    line
    if line != ""
  ]
  puzzle1_equations = {
    for row in range(0, length(local.puzzle1_lines)) :
    "${row}" => {
      test_value = split(": ", local.puzzle1_lines[row])[0]
      numbers    = split(" ", split(": ", local.puzzle1_lines[row])[1])
    }
  }
}

module "generate_equations" {
  for_each   = local.puzzle1_equations
  source     = "./modules/generate_equations"
  test_value = each.value.test_value
  numbers    = each.value.numbers
}

module "solve_equations" {
  for_each   = module.generate_equations
  source     = "./modules/solve_equations"
  test_value = each.value.test_value
  equations  = each.value.equations
}

locals {
  puzzle1_solution = sum([
    for row, equation in module.solve_equations :
    equation.test_value
  ])
}

output "puzzle1" {
  value = local.puzzle1_solution
  precondition {
    condition     = local.puzzle1_solution == 3749
    error_message = "Invalid result"
  }
}
