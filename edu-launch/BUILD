load("//tools/install:install.bzl", "install", "install_src_files")
load("//tools:cpplint.bzl", "cpplint")

package(default_visibility = ["//visibility:public"])

install(
    name = "install"
)

install_src_files(
    name = "install_src",
    src_dir = ["."],
    dest = "edu-launch",
    filter = "*",
)