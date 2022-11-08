load("//third_party/nlohmann_json:init.bzl", apollo_neo_3rd_nlohmann_json_dev_repo = "init")
load("//third_party/gtest:init.bzl", apollo_neo_3rd_gtest_dev_repo = "init")
load("//third_party/py:init.bzl", apollo_neo_3rd_py_dev_repo = "init")
load("//third_party/pcl:init.bzl", apollo_neo_3rd_pcl_dev_repo = "init")
load("//third_party/cpplint:init.bzl", apollo_neo_3rd_cpplint_dev_repo = "init")
load("//third_party/yaml_cpp:init.bzl", apollo_neo_3rd_yaml_cpp_dev_repo = "init")
load("//third_party/protobuf:init.bzl", apollo_neo_3rd_protobuf_dev_repo = "init")
load("//third_party/eigen3:init.bzl", apollo_neo_3rd_eigen3_dev_repo = "init")
load("//third_party/bazel_skylib:init.bzl", apollo_neo_3rd_bazel_skylib_dev_repo = "init")
load("//third_party/gpus:init.bzl", apollo_neo_3rd_gpus_dev_repo = "init")
load("//third_party/rules_proto:init.bzl", apollo_neo_3rd_rules_proto_dev_repo = "init")
load("//third_party/grpc:init.bzl", apollo_neo_3rd_grpc_dev_repo = "init")
load("//third_party/rules_python:init.bzl", apollo_neo_3rd_rules_python_dev_repo = "init")
load("//third_party/civetweb:init.bzl", apollo_neo_3rd_civetweb_dev_repo = "init")
def clean_dep(dep):
    return str(Label(dep))
def apollo_neo_3rd_absl_dev_repo():
    native.new_local_repository(
        name = "com_google_absl",
        build_file = clean_dep("//dev/bazel:3rd-absl-dev.BUILD"),
        path = "/opt/apollo/neo/packages/3rd-absl-dev/1.0.0.1",
    )
def system_libtinyxml2_dev_repo():
    native.new_local_repository(
        name = "tinyxml2",
        build_file = clean_dep("//dev/bazel:libtinyxml2-dev.BUILD"),
        path = "/usr/include",
    )
def apollo_neo_3rd_ipopt_dev_repo():
    native.new_local_repository(
        name = "ipopt",
        build_file = clean_dep("//dev/bazel:3rd-ipopt-dev.BUILD"),
        path = "/opt/apollo/neo/packages/3rd-ipopt-dev/1.0.0.1",
    )
def system_libncurses5_dev_repo():
    native.new_local_repository(
        name = "ncurses5",
        build_file = clean_dep("//dev/bazel:libncurses5-dev.BUILD"),
        path = "/usr/include",
    )
def system_libsqlite3_dev_repo():
    native.new_local_repository(
        name = "sqlite3",
        build_file = clean_dep("//dev/bazel:libsqlite3-dev.BUILD"),
        path = "/usr/include",
    )
def system_libadolc_dev_repo():
    native.new_local_repository(
        name = "adolc",
        build_file = clean_dep("//dev/bazel:libadolc-dev.BUILD"),
        path = "/usr/include",
    )
def apollo_neo_3rd_boost_dev_repo():
    native.new_local_repository(
        name = "boost",
        build_file = clean_dep("//dev/bazel:3rd-boost-dev.BUILD"),
        path = "/opt/apollo/neo/packages/3rd-boost-dev/1.0.0.1",
    )
def apollo_neo_3rd_tf2_dev_repo():
    native.new_local_repository(
        name = "tf2",
        build_file = clean_dep("//dev/bazel:3rd-tf2-dev.BUILD"),
        path = "/opt/apollo/neo/packages/3rd-tf2-dev/1.0.0.1",
    )
def apollo_neo_3rd_proj_dev_repo():
    native.new_local_repository(
        name = "proj",
        build_file = clean_dep("//dev/bazel:3rd-proj-dev.BUILD"),
        path = "/opt/apollo/neo/packages/3rd-proj-dev/1.0.0.1",
    )
def apollo_neo_3rd_ad_rss_lib_dev_repo():
    native.new_local_repository(
        name = "ad_rss_lib",
        build_file = clean_dep("//dev/bazel:3rd-ad-rss-lib-dev.BUILD"),
        path = "/opt/apollo/neo/packages/3rd-ad-rss-lib-dev/1.0.0.1",
    )
def apollo_neo_3rd_fastrtps_dev_repo():
    native.new_local_repository(
        name = "fastrtps",
        build_file = clean_dep("//dev/bazel:3rd-fastrtps-dev.BUILD"),
        path = "/opt/apollo/neo/packages/3rd-fastrtps-dev/1.0.0.1",
    )
def apollo_neo_3rd_libtorch_cpu_dev_repo():
    native.new_local_repository(
        name = "libtorch_cpu",
        build_file = clean_dep("//dev/bazel:3rd-libtorch-cpu-dev.BUILD"),
        path = "/opt/apollo/neo/packages/3rd-libtorch-cpu-dev/1.0.0.1",
    )
def system_libnuma_dev_repo():
    native.new_local_repository(
        name = "libnuma-dev",
        build_file = clean_dep("//dev/bazel:libnuma-dev.BUILD"),
        path = "/usr/include",
    )
def apollo_neo_3rd_gflags_dev_repo():
    native.new_local_repository(
        name = "com_github_gflags_gflags",
        build_file = clean_dep("//dev/bazel:3rd-gflags-dev.BUILD"),
        path = "/opt/apollo/neo/packages/3rd-gflags-dev/1.0.0.1",
    )
def apollo_neo_3rd_opencv_dev_repo():
    native.new_local_repository(
        name = "opencv",
        build_file = clean_dep("//dev/bazel:3rd-opencv-dev.BUILD"),
        path = "/opt/apollo/neo/packages/3rd-opencv-dev/1.0.0.1",
    )
def system_libuuid1_repo():
    native.new_local_repository(
        name = "uuid",
        build_file = clean_dep("//dev/bazel:libuuid1.BUILD"),
        path = "/usr/include",
    )
def common_msgs_dev_repo():
    native.new_local_repository(
        name = "common-msgs",
        build_file = clean_dep("//dev/bazel:common-msgs-dev.BUILD"),
        path = "/opt/apollo/neo/packages/common-msgs-dev/1.0.0.1",
    )
def apollo_neo_3rd_glog_dev_repo():
    native.new_local_repository(
        name = "com_github_google_glog",
        build_file = clean_dep("//dev/bazel:3rd-glog-dev.BUILD"),
        path = "/opt/apollo/neo/packages/3rd-glog-dev/1.0.0.1",
    )
def apollo_neo_cyber_dev_repo():
    native.new_local_repository(
        name = "cyber",
        build_file = clean_dep("//dev/bazel:cyber-dev.BUILD"),
        path = "/opt/apollo/neo/packages/cyber-dev/1.0.0.1",
    )
def apollo_neo_3rd_osqp_dev_repo():
    native.new_local_repository(
        name = "osqp",
        build_file = clean_dep("//dev/bazel:3rd-osqp-dev.BUILD"),
        path = "/opt/apollo/neo/packages/3rd-osqp-dev/1.0.0.1",
    )
def apollo_neo_common_dev_repo():
    native.new_local_repository(
        name = "common",
        build_file = clean_dep("//dev/bazel:common-dev.BUILD"),
        path = "/opt/apollo/neo/packages/common-dev/1.0.0.1",
    )
def apollo_neo_map_dev_repo():
    native.new_local_repository(
        name = "map",
        build_file = clean_dep("//dev/bazel:map-dev.BUILD"),
        path = "/opt/apollo/neo/packages/map-dev/1.0.0.2",
    )
def apollo_neo_planning_dev_repo():
    native.new_local_repository(
        name = "planning",
        build_file = clean_dep("//dev/bazel:planning.BUILD"),
        path = "/opt/apollo/neo/packages/planning-dev/local",
    )
def apollo_neo_transform_dev_repo():
    native.new_local_repository(
        name = "transform",
        build_file = clean_dep("//dev/bazel:transform-dev.BUILD"),
        path = "/opt/apollo/neo/packages/transform-dev/1.0.0.1",
    )
def apollo_neo_prediction_dev_repo():
    native.new_local_repository(
        name = "prediction",
        build_file = clean_dep("//dev/bazel:prediction-dev.BUILD"),
        path = "/opt/apollo/neo/packages/prediction-dev/1.0.0.1",
    )
def apollo_neo_dreamview_dev_repo():
    native.new_local_repository(
        name = "dreamview",
        build_file = clean_dep("//dev/bazel:dreamview-dev.BUILD"),
        path = "/opt/apollo/neo/packages/dreamview-dev/1.0.0.2",
    )
def apollo_neo_task_manager_dev_repo():
    native.new_local_repository(
        name = "task-manager",
        build_file = clean_dep("//dev/bazel:task-manager-dev.BUILD"),
        path = "/opt/apollo/neo/packages/task-manager-dev/1.0.0.1",
    )
def apollo_neo_monitor_dev_repo():
    native.new_local_repository(
        name = "monitor",
        build_file = clean_dep("//dev/bazel:monitor-dev.BUILD"),
        path = "/opt/apollo/neo/packages/monitor-dev/1.0.0.2",
    )
def apollo_neo_routing_dev_repo():
    native.new_local_repository(
        name = "routing",
        build_file = clean_dep("//dev/bazel:routing-dev.BUILD"),
        path = "/opt/apollo/neo/packages/routing-dev/1.0.0.1",
    )
def init_deps():
    apollo_neo_3rd_nlohmann_json_dev_repo()
    apollo_neo_3rd_gtest_dev_repo()
    apollo_neo_3rd_py_dev_repo()
    apollo_neo_3rd_pcl_dev_repo()
    apollo_neo_3rd_cpplint_dev_repo()
    apollo_neo_3rd_yaml_cpp_dev_repo()
    apollo_neo_3rd_protobuf_dev_repo()
    apollo_neo_3rd_eigen3_dev_repo()
    apollo_neo_3rd_bazel_skylib_dev_repo()
    apollo_neo_3rd_gpus_dev_repo()
    apollo_neo_3rd_rules_proto_dev_repo()
    apollo_neo_3rd_grpc_dev_repo()
    apollo_neo_3rd_rules_python_dev_repo()
    apollo_neo_3rd_civetweb_dev_repo()
    apollo_neo_3rd_absl_dev_repo()
    system_libtinyxml2_dev_repo()
    apollo_neo_3rd_ipopt_dev_repo()
    system_libncurses5_dev_repo()
    system_libsqlite3_dev_repo()
    system_libadolc_dev_repo()
    apollo_neo_3rd_boost_dev_repo()
    apollo_neo_3rd_tf2_dev_repo()
    apollo_neo_3rd_proj_dev_repo()
    apollo_neo_3rd_ad_rss_lib_dev_repo()
    apollo_neo_3rd_fastrtps_dev_repo()
    apollo_neo_3rd_libtorch_cpu_dev_repo()
    system_libnuma_dev_repo()
    apollo_neo_3rd_gflags_dev_repo()
    apollo_neo_3rd_opencv_dev_repo()
    system_libuuid1_repo()
    common_msgs_dev_repo()
    apollo_neo_3rd_glog_dev_repo()
    apollo_neo_cyber_dev_repo()
    apollo_neo_3rd_osqp_dev_repo()
    apollo_neo_common_dev_repo()
    apollo_neo_map_dev_repo()
    apollo_neo_planning_dev_repo()
    apollo_neo_transform_dev_repo()
    apollo_neo_prediction_dev_repo()
    apollo_neo_dreamview_dev_repo()
    apollo_neo_task_manager_dev_repo()
    apollo_neo_monitor_dev_repo()
    apollo_neo_routing_dev_repo()