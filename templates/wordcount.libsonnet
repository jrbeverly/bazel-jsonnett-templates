local api = import "lib/api/models/v1.0/model.libsonnet";
local list = ['s3.json', 'iam/policy.json'];

{
    name:: 'abc',
    generate(config):: 
        local bucket = api.S3Bucket{ name: config.name };
        { [key]: bucket for key in list },
}