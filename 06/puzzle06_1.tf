locals {
  puzzle1_lines = [
    for line in split("\n", file("input.txt")) :
    line
    if line != ""
  ]
}

module "move" {
  source = "./modules/unfold_4"
  map    = local.puzzle1_lines
}
locals {
  puzzle1_solution = sum([
    for line in module.move.map :
    length(regexall("[X^>v<]", line))
  ])
}

output "puzzle1" {
  value = local.puzzle1_solution
  #Warning would have been nice here 8)
  precondition {
    condition = anytrue([
      local.puzzle1_solution == 4656,
    ])
    error_message = "Invalid result"
  }
}

output "puzzle1_finished" {
  value = module.move.finished
}
