variable "test_value" {
  type = number
}

variable "numbers" {
  type = list(number)
}

locals {
  operator_combinations = length(var.numbers) == 2 ? [
    ["*"],
    ["+"],
    ] : setproduct([
      for i in range(0, length(var.numbers) - 1) :
      [
        "*",
        "+",
      ]
  ]...)
  equations = {
    for operators in local.operator_combinations :
    "test_${join("", operators)}" => flatten([
      {
        num = var.numbers[0]
        op  = null
      },
      [
        for i in range(0, length(operators)) :
        {
          num = var.numbers[i + 1]
          op  = operators[i]
        }
      ]
    ])
  }
}

output "test_value" {
  value = var.test_value
}

output "test_valid" {
  value = false
}

output "equations" {
  value = local.equations
}
