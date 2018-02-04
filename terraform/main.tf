provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "codebuild_role" {
  name = "codebuild-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "codebuild_policy" {
  name = "codebuild-policy"
  path = "/service-role/"
  description = "Policy used in trust relationship with CodeBuild"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    }
  ]
}
POLICY
}

resource "aws_iam_policy_attachment" "codebuild_policy_attachment" {
  name = "codebuild-policy-attachment"
  policy_arn = "${aws_iam_policy.codebuild_policy.arn}"
  roles = ["${aws_iam_role.codebuild_role.id}"]
}

resource "aws_codebuild_project" "code-build-test-project" {
  name = "code-build-test-project"
  description = "Learn how to use CodeBuild for java project (nutrienrob/code-pipeline-test)."
  build_timeout = "5"
  service_role = "${aws_iam_role.codebuild_role.arn}"

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image = "2"
    type = "LINUX_CONTAINER"
  }

  source {
    type = "GITHUB"
    location = "https://github.com/nutrienrob/code-pipeline-test.git"
  }
  /*
  Was automatically created by Intellij's Terraform plugin when creating the
  new resource.
  "artifacts" {
    type = ""
  }
  "environment" {
    compute_type = ""
    image = ""
    type = ""
  }
  name = ""
  "source" {
    type = ""
  }
  */
}