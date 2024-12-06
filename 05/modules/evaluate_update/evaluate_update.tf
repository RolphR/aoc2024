variable "update" {
  type        = list(number)
  description = "Update line"
  validation {
    condition     = length(var.update) % 2 == 1
    error_message = "There is no center value (length is even)"
  }
}

variable "orderings" {
  type = list(list(number))
}

locals {
  # Just reverse (transpose) the order to make a list of all invalid rules
  invalid_rule_map = transpose({
    for x in toset(var.update) :
    x => toset([
      for order in var.orderings :
      order[1]
      if tonumber(order[0]) == tonumber(x)
    ])
  })
  valid_update = alltrue([
    for index in range(0, length(var.update) - 1) :
    length(setintersection(
      lookup(local.invalid_rule_map, var.update[index], toset([])),
      slice(var.update, index + 1, length(var.update)),
    )) == 0
  ])

  # Puzzle 2:
  pages_ordering = {
    for page in var.update :
    length(lookup(local.invalid_rule_map, page, toset([]))) => page
  }
  corrected_update = [
    for order in range(0, length(var.update)) :
    local.pages_ordering["${order}"]
  ]
}

output "debug" {
  value = {
    update           = var.update
    orderings        = var.orderings
    invalid_rule_map = local.invalid_rule_map
    pages_ordering   = local.pages_ordering
    corrected_update = local.corrected_update
  }
}

output "valid" {
  value = local.valid_update
}

output "center_value" {
  value = local.valid_update ? var.update[floor(length(var.update) / 2)] : 0
}

output "corrected_center_value" {
  value = local.valid_update ? 0 : local.corrected_update[floor(length(local.corrected_update) / 2)]
}
