# Create the SG
resource "aws_security_group" "vsh_rdp_sg" {
  name        = "VSH Demo RDP Security Group"
  description = "Allows RDP sessions to Windows Servers"

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "VSH Demo RDP Security Group"
  }
}

# Store the ID for the Security Group
resource "aws_ssm_parameter" "vsh_rdp_sg_parameter" {
  name      = "/VSH/SG/ID"
  value     = aws_security_group.vsh_rdp_sg.id
  type      = "String"
  overwrite = true
}


resource "aws_sns_topic" "vhs_sns_send_info" {
  name = "vhs-sns"
}



#IAM Document
#Allow CodeBuild to assume Role
data "aws_iam_policy_document" "allow_codebuild_assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
        "codebuild.amazonaws.com"
      ]
    }
  }
}
#IAM Document
#Allow Codebuild various Actions
data "aws_iam_policy_document" "allow_codebuild_actions" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:*",
      "lambda:*",
      "s3:*",
      "logs:*",
      "sns:*",
      "ssm:*"
    ]
    resources = ["*"]
  }
}
#IAM Policy
#Allow CodeBuild Assume
resource "aws_iam_policy" "allow_codebuild_actions_policy" {
  name   = "VSH_DEMO_CODEBUILD_ACTIONS_POLICY"
  policy = data.aws_iam_policy_document.allow_codebuild_actions.json
}

resource "aws_iam_role" "vsh_codebuild_execution_role" {
  name               = "VSH_CODEBUILD_ROLE"
  assume_role_policy = data.aws_iam_policy_document.allow_codebuild_assume.json
}

resource "aws_iam_role_policy_attachment" "vsh_codebuild_execution_role_attach_actions" {
  role       = aws_iam_role.vsh_codebuild_execution_role.name
  policy_arn = aws_iam_policy.allow_codebuild_actions_policy.arn
}


resource "aws_codebuild_project" "vsh_codebuild_project" {
  name         = "VSH_Build_Server"
  description  = "CodeBuild project that builds requested servers"
  service_role = aws_iam_role.vsh_codebuild_execution_role.arn


  source {
    type            = "GITHUB"
    location        = "https://github.com/corykitchens/vhs.git"
    git_clone_depth = 1
  }

  artifacts {
    type = "NO_ARTIFACTS"
  }


  environment {
    compute_type = "BUILD_GENERAL1_LARGE"
    image        = "aws/codebuild/standard:2.0"
    type         = "LINUX_CONTAINER"

    environment_variable {
      name  = "SNS_TOPIC_ARN"
      value = aws_sns_topic.vhs_sns_send_info.arn
    }

    environment_variable {
      name  = "KEY_NAME"
      value = "default_key_name"
    }

    environment_variable {
      name  = "INSTANCE_SIZE"
      value = "t2.micro"
    }
  }
}
