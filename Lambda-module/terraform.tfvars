stream_name     = "Lambda-stream"
shard_count     = 1
function_name   = "client-provided-function-name"
handler         = "com.example.MyLambdaFunction::handleRequest"
runtime         = "java17"
memory_size     = 512
timeout         = 900
role            = "arn:aws:iam::123456789012:role/your-iam-role"
layers          = ["arn:aws:lambda:us-east-1:123456789012:layer:em-thirdparty-layer:12"]
bucket_name     = ""
object_key      = " "
source_url      = " "
environment = {
  ENABLE_ENHANCED_MONITORING = "false"
  ENABLE_CODE_PROFILING     = "false"
}
