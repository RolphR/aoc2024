variable "lines" {
  type = list(string)
  validation {
    condition     = length(var.lines) == 3
    error_message = "Need exactly 3 lines"
  }
}

locals {
  top_line    = var.lines[0]
  center_line = var.lines[1]
  bottom_line = var.lines[2]
  count = length([
    for col in range(1, length(local.center_line) - 1) :
    true
    if alltrue([
      substr(local.center_line, col, 1) == "A",
      anytrue([
        alltrue([
          substr(local.top_line, col - 1, 1) == "M",
          substr(local.bottom_line, col + 1, 1) == "S",
        ]),
        alltrue([
          substr(local.top_line, col - 1, 1) == "S",
          substr(local.bottom_line, col + 1, 1) == "M",
        ]),
      ]),
      anytrue([
        alltrue([
          substr(local.top_line, col + 1, 1) == "M",
          substr(local.bottom_line, col - 1, 1) == "S",
        ]),
        alltrue([
          substr(local.top_line, col + 1, 1) == "S",
          substr(local.bottom_line, col - 1, 1) == "M",
        ]),
      ]),
    ])
  ])
}

output "count" {
  value = local.count
}
