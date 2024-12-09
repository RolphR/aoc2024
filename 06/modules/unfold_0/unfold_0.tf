variable "map" {
  type = list(string)
}

module "move_0" {
  source = "../move"
  map    = var.map
}
module "move_1" {
  source = "../move"
  map    = module.move_0.map
}
module "move_2" {
  source = "../move"
  map    = module.move_1.map
}
module "move_3" {
  source = "../move"
  map    = module.move_2.map
}
module "move_4" {
  source = "../move"
  map    = module.move_3.map
}
module "move_5" {
  source = "../move"
  map    = module.move_4.map
}
module "move_6" {
  source = "../move"
  map    = module.move_5.map
}
module "move_7" {
  source = "../move"
  map    = module.move_6.map
}
module "move_8" {
  source = "../move"
  map    = module.move_7.map
}
module "move_9" {
  source = "../move"
  map    = module.move_8.map
}

output "map" {
  value = module.move_9.map
}

output "finished" {
  value = module.move_9.finished
}
