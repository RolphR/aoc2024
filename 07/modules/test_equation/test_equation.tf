variable "test_value" {
  type = number
}

variable "equation" {
  type = list(object({
    num = number
    op  = optional(string, null)
  }))
  validation {
    condition     = length(var.equation) <= 13
    error_message = "Too many operators"
  }
}

locals {
  operator_count = length(var.equation) - 1
}

module "operator_1" {
  count     = 1 <= local.operator_count ? 1 : 0
  source    = "../operator"
  num_left  = var.equation[0].num
  operator  = var.equation[1].op
  num_right = var.equation[1].num
}
module "operator_2" {
  count     = 2 <= local.operator_count ? 1 : 0
  source    = "../operator"
  num_left  = module.operator_1[0].result
  operator  = var.equation[2].op
  num_right = var.equation[2].num
}
module "operator_3" {
  count     = 3 <= local.operator_count ? 1 : 0
  source    = "../operator"
  num_left  = module.operator_2[0].result
  operator  = var.equation[3].op
  num_right = var.equation[3].num
}
module "operator_4" {
  count     = 4 <= local.operator_count ? 1 : 0
  source    = "../operator"
  num_left  = module.operator_3[0].result
  operator  = var.equation[4].op
  num_right = var.equation[4].num
}
module "operator_5" {
  count     = 5 <= local.operator_count ? 1 : 0
  source    = "../operator"
  num_left  = module.operator_4[0].result
  operator  = var.equation[5].op
  num_right = var.equation[5].num
}
module "operator_6" {
  count     = 6 <= local.operator_count ? 1 : 0
  source    = "../operator"
  num_left  = module.operator_5[0].result
  operator  = var.equation[6].op
  num_right = var.equation[6].num
}
module "operator_7" {
  count     = 7 <= local.operator_count ? 1 : 0
  source    = "../operator"
  num_left  = module.operator_6[0].result
  operator  = var.equation[7].op
  num_right = var.equation[7].num
}
module "operator_8" {
  count     = 8 <= local.operator_count ? 1 : 0
  source    = "../operator"
  num_left  = module.operator_7[0].result
  operator  = var.equation[8].op
  num_right = var.equation[8].num
}
module "operator_9" {
  count     = 9 <= local.operator_count ? 1 : 0
  source    = "../operator"
  num_left  = module.operator_8[0].result
  operator  = var.equation[9].op
  num_right = var.equation[9].num
}
module "operator_10" {
  count     = 10 <= local.operator_count ? 1 : 0
  source    = "../operator"
  num_left  = module.operator_9[0].result
  operator  = var.equation[10].op
  num_right = var.equation[10].num
}
module "operator_11" {
  count     = 11 <= local.operator_count ? 1 : 0
  source    = "../operator"
  num_left  = module.operator_10[0].result
  operator  = var.equation[11].op
  num_right = var.equation[11].num
}
module "operator_12" {
  count     = 12 <= local.operator_count ? 1 : 0
  source    = "../operator"
  num_left  = module.operator_11[0].result
  operator  = var.equation[12].op
  num_right = var.equation[12].num
}

locals {
  equation_values = compact(flatten([
    module.operator_1[*].result,
    module.operator_2[*].result,
    module.operator_3[*].result,
    module.operator_4[*].result,
    module.operator_5[*].result,
    module.operator_6[*].result,
    module.operator_7[*].result,
    module.operator_8[*].result,
    module.operator_9[*].result,
    module.operator_10[*].result,
    module.operator_11[*].result,
    module.operator_12[*].result,
  ]))
  equation_value = tonumber(local.equation_values[length(local.equation_values) - 1])
}

output "equation_value" {
  value = local.equation_value
}

output "test_value" {
  value = var.test_value
}

output "valid" {
  value = local.equation_value == var.test_value
}

output "equation" {
  value = var.equation
}
