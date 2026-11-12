get_filename_component(WORK "${CMAKE_CURRENT_LIST_DIR}/../.." ABSOLUTE)
set(REPO "${WORK}/qemu-render-20261111")
set(BODY "${WORK}/fox-body-native-20261111")
set(NATIVE "${REPO}/main/ayatsuri/ayatsuri_model.c" "${REPO}/main/ayatsuri/ayatsuri_visibility.c" "${REPO}/main/ayatsuri/compact_opaque.c" "${REPO}/main/ui/kasane/ksn_shiki_frame.c" "${REPO}/main/ui/kasane/ksn_mesh_depth.c")
idf_component_register(SRCS "target_main.c" "${BODY}/body_render.c" ${NATIVE}
 INCLUDE_DIRS "${REPO}/main" "${REPO}/main/ayatsuri" "${BODY}" "${WORK}/hone-dq-converter-20261106/main/ayatsuri"
 REQUIRES esp_timer heap)
target_compile_definitions(${COMPONENT_LIB} PRIVATE TARGET_BODY=1)
target_compile_options(${COMPONENT_LIB} PRIVATE -ffp-contract=off -fno-fast-math -UNDEBUG -Wno-error -Wno-format -fstack-usage)
