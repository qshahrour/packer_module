# ==================================================
# Development Server
#   * AWS Instance        =>  http
#   * Launch Template     =>  http template
#   * AutoScaling Group   =>  http group
# ==================================================
resource "aws_instance" "http" {
  ami                  = "${data.aws_ami.Windows_2016.image_id}"
  instance_type        = "${var.instance}"
  key_name             = "${module.ssh_key_pair.key_name}"
  subnet_id            = "${data.aws_subnet_ids.selected.ids[01]}"
  security_groups      = ["${data.aws_security_group.selected.id}"]
  user_data            = "${data.template_file.user_data.rendered}"
  iam_instance_profile = "${var.iam_role}"
  get_password_data    = "true"

  root_block_device {
    volume_type           = "${var.volume_type}"
    volume_size           = "${var.volume_size}"
    delete_on_termination = "true"
  }
}
  //tags {
  //  Name    = "NEW_windows2016"
  //  Role    = "Dev"
  //}

# ==================================================
resource "aws_launch_template" "http_temp" {
  name_prefix   = "dev"
  image_id      = "${data.aws_ami.Windows_2016.image_id}"
  instance_type = "${var.instance}"
}

resource "aws_autoscaling_group" "http" {
  availability_zones = ["eu-west-2"]
  desired_capacity   = 3
  max_size           = 6
  min_size           = 3

  launch_template {
    id      = aws_launch_template.http_temp.id
    version = "$Latest"
  }
}
# ==================================================
#--- Copy ssh keys to S3 Bucket
//provisioner "local-exec" {
//  command = "aws s3 cp ${path.module}/secret s3://PATHTOKEYPAIR/ --recursive"
//}
