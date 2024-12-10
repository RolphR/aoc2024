variable "test_value" {
  type = number
}

variable "equations" {
  type = map(list(object({
    num = number
    op  = optional(string, null)
  })))
}

module "equation" {
  for_each   = var.equations
  source     = "../test_equation"
  equation   = each.value
  test_value = var.test_value
}

output "test_value" {
  value = anytrue([
    for id, equation in module.equation :
    equation.valid
  ]) ? var.test_value : 0
}

output "valid_equations" {
  value = [
    for id, equation in module.equation :
    equation
    if equation.valid
  ]
}
