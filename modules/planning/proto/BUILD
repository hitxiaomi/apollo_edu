## Auto generated by `proto_build_generator.py`
load("@rules_proto//proto:defs.bzl", "proto_library")
load("@rules_cc//cc:defs.bzl", "cc_proto_library")
load("//tools:python_rules.bzl", "py_proto_library")

package(default_visibility = ["//visibility:public"])

cc_proto_library(
    name = "st_drivable_boundary_cc_proto",
    deps = [
        ":st_drivable_boundary_proto",
    ],
)

proto_library(
    name = "st_drivable_boundary_proto",
    srcs = ["st_drivable_boundary.proto"],
)

py_proto_library(
    name = "st_drivable_boundary_py_pb2",
    deps = [
        ":st_drivable_boundary_proto",
    ],
)

cc_proto_library(
    name = "planning_stats_cc_proto",
    deps = [
        ":planning_stats_proto",
    ],
)

proto_library(
    name = "planning_stats_proto",
    srcs = ["planning_stats.proto"],
)

py_proto_library(
    name = "planning_stats_py_pb2",
    deps = [
        ":planning_stats_proto",
    ],
)
cc_proto_library(
    name = "planning_semantic_map_config_cc_proto",
    deps = [
        ":planning_semantic_map_config_proto",
    ],
)

proto_library(
    name = "planning_semantic_map_config_proto",
    srcs = ["planning_semantic_map_config.proto"],
)

py_proto_library(
    name = "planning_semantic_map_config_py_pb2",
    deps = [
        ":planning_semantic_map_config_proto",
    ],
)
cc_proto_library(
    name = "traffic_rule_config_cc_proto",
    deps = [
        ":traffic_rule_config_proto",
    ],
)

proto_library(
    name = "traffic_rule_config_proto",
    srcs = ["traffic_rule_config.proto"],
)

py_proto_library(
    name = "traffic_rule_config_py_pb2",
    deps = [
        ":traffic_rule_config_proto",
    ],
)

cc_proto_library(
    name = "planning_status_cc_proto",
    deps = [
        ":planning_status_proto",
    ],
)

proto_library(
    name = "planning_status_proto",
    srcs = ["planning_status.proto"],
    deps = [
        "//modules/common_msgs/basic_msgs:geometry_proto",
        "//modules/common_msgs/planning_msgs:planning_config_proto",
        "//modules/common_msgs/routing_msgs:routing_proto",
        "//modules/common_msgs/planning_msgs:scenario_type_proto",
    ],
)

py_proto_library(
    name = "planning_status_py_pb2",
    deps = [
        ":planning_status_proto",
        "//modules/common_msgs/basic_msgs:geometry_py_pb2",
        "//modules/common_msgs/planning_msgs:planning_config_py_pb2",
        "//modules/common_msgs/routing_msgs:routing_py_pb2",
        "//modules/common_msgs/planning_msgs:scenario_type_py_pb2",
    ],
)

cc_proto_library(
    name = "lattice_structure_cc_proto",
    deps = [
        ":lattice_structure_proto",
    ],
)

proto_library(
    name = "lattice_structure_proto",
    srcs = ["lattice_structure.proto"],
)

py_proto_library(
    name = "lattice_structure_py_pb2",
    deps = [
        ":lattice_structure_proto",
    ],
)
cc_proto_library(
    name = "learning_data_cc_proto",
    deps = [
        ":learning_data_proto",
    ],
)

proto_library(
    name = "learning_data_proto",
    srcs = ["learning_data.proto"],
    deps = [
        "//modules/common_msgs/chassis_msgs:chassis_proto",
        "//modules/common_msgs/basic_msgs:geometry_proto",
        "//modules/common_msgs/basic_msgs:header_proto",
        "//modules/common_msgs/basic_msgs:pnc_point_proto",
        "//modules/common_msgs/map_msgs:map_lane_proto",
        "//modules/common_msgs/perception_msgs:perception_obstacle_proto",
        "//modules/common_msgs/prediction_msgs:feature_proto",
        "//modules/common_msgs/prediction_msgs:prediction_obstacle_proto",
        "//modules/common_msgs/perception_msgs:traffic_light_detection_proto",
        "//modules/common_msgs/routing_msgs:routing_proto",
    ],
)

py_proto_library(
    name = "learning_data_py_pb2",
    deps = [
        ":learning_data_proto",
        "//modules/common_msgs/chassis_msgs:chassis_py_pb2",
        "//modules/common_msgs/basic_msgs:geometry_py_pb2",
        "//modules/common_msgs/basic_msgs:header_py_pb2",
        "//modules/common_msgs/basic_msgs:pnc_point_py_pb2",
        "//modules/common_msgs/map_msgs:map_lane_py_pb2",
        "//modules/common_msgs/perception_msgs:perception_obstacle_py_pb2",
        "//modules/common_msgs/prediction_msgs:feature_py_pb2",
        "//modules/common_msgs/prediction_msgs:prediction_obstacle_py_pb2",
        "//modules/common_msgs/perception_msgs:traffic_light_detection_py_pb2",
        "//modules/common_msgs/routing_msgs:routing_py_pb2",
    ],
)

cc_proto_library(
    name = "auto_tuning_model_input_cc_proto",
    deps = [
        ":auto_tuning_model_input_proto",
    ],
)

proto_library(
    name = "auto_tuning_model_input_proto",
    srcs = ["auto_tuning_model_input.proto"],
)

py_proto_library(
    name = "auto_tuning_model_input_py_pb2",
    deps = [
        ":auto_tuning_model_input_proto",
    ],
)
cc_proto_library(
    name = "auto_tuning_raw_feature_cc_proto",
    deps = [
        ":auto_tuning_raw_feature_proto",
    ],
)

proto_library(
    name = "auto_tuning_raw_feature_proto",
    srcs = ["auto_tuning_raw_feature.proto"],
    deps = [
        "//modules/common_msgs/basic_msgs:pnc_point_proto",
    ],
)

py_proto_library(
    name = "auto_tuning_raw_feature_py_pb2",
    deps = [
        ":auto_tuning_raw_feature_proto",
        "//modules/common_msgs/basic_msgs:pnc_point_py_pb2",
    ],
)

cc_proto_library(
    name = "reference_line_smoother_config_cc_proto",
    deps = [
        ":reference_line_smoother_config_proto",
    ],
)

proto_library(
    name = "reference_line_smoother_config_proto",
    srcs = ["reference_line_smoother_config.proto"],
    deps = [
        "//modules/planning/proto/math:cos_theta_smoother_config_proto",
        "//modules/common_msgs/planning_msgs:fem_pos_deviation_smoother_config_proto",
    ],
)

py_proto_library(
    name = "reference_line_smoother_config_py_pb2",
    deps = [
        ":reference_line_smoother_config_proto",
        "//modules/planning/proto/math:cos_theta_smoother_config_py_pb2",
        "//modules/common_msgs/planning_msgs:fem_pos_deviation_smoother_config_py_pb2",
    ],
)

cc_proto_library(
    name = "ipopt_return_status_cc_proto",
    deps = [
        ":ipopt_return_status_proto",
    ],
)

proto_library(
    name = "ipopt_return_status_proto",
    srcs = ["ipopt_return_status.proto"],
)

py_proto_library(
    name = "ipopt_return_status_py_pb2",
    deps = [
        ":ipopt_return_status_proto",
    ],
)
