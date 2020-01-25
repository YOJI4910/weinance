resource "aws_ecs_task_definition" "sample-task" {
  family                = "webapp-service"
  container_definitions = file("./jsonfiles/service.json")
  task_role_arn         = aws_iam_role.ecs_task_role.arn
  execution_role_arn    = aws_iam_role.ecs_task_role.arn
  network_mode          = "bridge"
}

resource "aws_ecs_task_definition" "rails-migrate" {
  family                = "rails-migrate"
  container_definitions = file("./jsonfiles/migration.json")
  execution_role_arn    = aws_iam_role.ecs_task_role.arn
  network_mode          = "bridge"
}