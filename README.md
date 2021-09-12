# Bazel & Jsonnet Templates

Generating files from base configuration files using Jsonnet.

## Notes

Exploring the idea of leveraging jsonnet with Bazel to create a series of templates sourced from configuration files. The basic principle of this is how to built in-repository the idea of `∀ ∈ Configuration Files { template([inputs]) => rendered }`.

The usage of libsonnet lets the `lib/` directory contain all of the models, utilities and other means of representing the data structures. Having a structure form to the data is in comparison to other templating systems like `gomplate` that typically just work off the idea of a text template. Having the structure means that we can leverage transforms to manipulate the data is a logical way, then render it as the expected output text.

Support for "aspect" style transformations of the data is fairly useful as well, as it gives the opportunity to apply things like `tags` to every resource.

Although this makes the generation of templated data better, it feels like just a more involved templating process, that as the system becomes sufficiently complex, it will eventually be seen as better to transition to a language/DSL better suited to the specialzied task (e.g. `terraform`, `skylark`, `hcl`)
