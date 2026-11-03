# 
# Usage: To re-create this platform project launch xsct with below options.
# xsct platform.tcl
# 
# OR launch xsct and run below command.
# source platform.tcl
# 
# To create the platform in a different location, modify the -out option of "platform create" command.
# -out option specifies the output directory of the platform project.

platform create -name {my_platform}\
-hw {./hw/system_wrapper.xsa}\
-proc {ps7_cortexa9_0} -os {standalone} -fsbl-target {psu_cortexa53_0} -out {.}

platform write
platform generate -domains 
platform active {my_platform}
platform generate
platform active {my_platform}
platform config -updatehw {./hw/system_wrapper.xsa}
platform generate -domains 
platform clean
platform generate
platform active {my_platform}
platform config -updatehw {./hw/system_wrapper.xsa}
platform clean
platform generate
platform active {my_platform}
platform config -updatehw {./hw/system_wrapper.xsa}
platform clean
platform generate
platform active {my_platform}
platform config -updatehw {./hw/system_wrapper.xsa}
platform clean
platform generate
platform clean
platform generate
platform active {my_platform}
platform config -updatehw {./hw/system_wrapper.xsa}
platform clean
platform generate
platform clean
platform generate
platform config -updatehw {./hw/system_wrapper.xsa}
platform generate -domains 
platform clean
platform config -updatehw {./hw/system_wrapper.xsa}
platform generate
platform clean
platform generate
platform config -updatehw {./hw/system_wrapper.xsa}
platform clean
platform config -updatehw {./hw/system_wrapper.xsa}
platform generate
platform clean
platform generate
platform config -updatehw {./hw/system_wrapper.xsa}
platform generate -domains 
platform active {my_platform}
platform config -updatehw {./hw/system_wrapper.xsa}
platform clean
platform generate
platform config -updatehw {./hw/system_wrapper.xsa}
platform generate -domains 
platform active {my_platform}
platform config -updatehw {./hw/system_wrapper.xsa}
platform clean
platform config -updatehw {./hw/system_wrapper.xsa}
platform generate
platform clean
platform generate
platform active {my_platform}
platform config -updatehw {./hw/system_wrapper.xsa}
platform clean
platform generate
platform clean
platform config -updatehw {./hw/system_wrapper.xsa}
platform generate
platform active {my_platform}
platform clean
platform config -updatehw {./hw/system_wrapper.xsa}
platform generate
platform config -updatehw {./hw/system_wrapper.xsa}
platform clean
platform config -updatehw {./hw/system_wrapper.xsa}
platform generate
platform clean
platform config -updatehw {./hw/system_wrapper.xsa}
platform generate
platform active {my_platform}
platform clean
platform config -updatehw {./hw/system_wrapper.xsa}
platform generate
platform config -updatehw {./hw/system_wrapper.xsa}
platform generate -domains 
