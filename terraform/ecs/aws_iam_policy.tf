resource "aws_iam_policy" "deployer-policy" {
  name        = "deploy"
  path        = "/"
  description = "deploy policy"
  policy      = file("./jsonfiles/ecr_policy.json")
}

resource "aws_iam_policy" "ecs_instance_policy" {
  name        = "ecs-instance-policy"
  path        = "/"
  description = ""
  policy      = file("./jsonfiles/ecs_instance_policy.json")
}

resource "aws_iam_policy" "ecs_task_policy" {
  name        = "ecs-task-policy"
  path        = "/"
  description = ""
  policy      = file("./jsonfiles/ecs_task_policy.json")
}
