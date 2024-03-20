# ==================================================
# availabilityzones Resource:
#   * State
#   * All
# ==================================================

data "aws_availability_zones" "available" {
  state = "available"
}
# ==================================================
# e.g., Create subnets in the first two available availability zones
# By Filter
//resource "aws_subnet" "primary" {
//  availability_zone = data.aws_availability_zones.available.names[0]
//
//  # ...
//}
# ==================================================
//resource "aws_subnet" "secondary" {
//  availability_zone = data.aws_availability_zones.available.names[1]
//
//  # ...
//} 
# ==================================================
data "aws_availability_zones" "az" {
  all_availability_zones = true

  filter {
    name   = "opt-in-status"
    values = ["not-opted-in", "opted-in"]
  }
}
# ==================================================
