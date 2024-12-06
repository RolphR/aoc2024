locals {
  puzzle1_lines = try(
    jsondecode(file("terraform.tfstate")).resources[0].instances[0].attributes.input.value,
    [
      for line in split("\n", file("input.txt")) :
      line
      if line != ""
    ]
  )
}

module "move" {
  source = "./modules/move"
  map    = local.puzzle1_lines
}

resource "terraform_data" "step" {
  input = module.move.map
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
      !module.move.finished,
      local.puzzle1_solution == 4656,
    ])
    error_message = "Invalid result"
  }
}

output "puzzle1_finished" {
  value = module.move.finished
}
