resource "aws_lambda_function" "execute_emr" {
  filename      = "lambda_function_payload.zip" # para subir uma função lambda, é necessário comprimir este arquivo python (junto com seus modúlos ou tudo que é preciso para sua execução) em um .zip
  function_name = "lambda_create_emr"
  role          = aws_iam_role.lambda.arn
  handler       = "lambda_function.handler"
  memory_size   = 128
  timeout       = 30

  source_code_hash = filebase64sha256("lambda_function_payload.zip")

  runtime = "python3.8"
}