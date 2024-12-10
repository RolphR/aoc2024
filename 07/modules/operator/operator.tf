variable "num_left" {
  type = number
}

variable "operator" {
  type = string
}

variable "num_right" {
  type = number
}

output "result" {
  value = lookup({
    "+" = var.num_left + var.num_right
    "*" = var.num_left * var.num_right
  }, var.operator)
}
