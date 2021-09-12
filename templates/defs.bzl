load(
    "@io_bazel_rules_jsonnet//jsonnet:jsonnet.bzl",
    "jsonnet_to_json",
)

def _basename(path):
    return path.split('/')[-2]

def data_entries(prefix, srcs):
    for entry in srcs:
        name = _basename(entry)
        wordcount_template(
            name = name,
            src = entry,
        )

def wordcount_template(name, src, files=[]):
    jsonnet_to_json(
        name = name,
        src = src,
        outs = ["%s/s3.json" % (name), "%s/iam/policy.json" % (name)],
        deps = ["//lib", "//templates"],
        ext_str_files = native.glob(["%s/*.json" % (name)]) + files,
        multiple_outputs = 1,
    )

def _impl(ctx):
    script = ctx.actions.declare_file("%s.sh" % (ctx.label.name))
    output = ctx.actions.declare_file("%s.json" % (ctx.label.name))
    ctx.actions.write(
        output = script,
        content = "jq -s . $@ > {out}".format(
            out = output.path,
        ),
        is_executable = True,
    )

    args = [f.path for f in ctx.files.srcs]
    ctx.actions.run(
        inputs = ctx.files.srcs,
        outputs = [output],
        arguments = args,
        progress_message = "Merging into %s" % output.short_path,
        executable = script,
    )
    return [DefaultInfo(files = depset([output]))]

json_combine = rule(
    implementation = _impl,
    attrs = {
        "srcs": attr.label_list(
            mandatory = True,
            allow_files = True
        ),
    },
)