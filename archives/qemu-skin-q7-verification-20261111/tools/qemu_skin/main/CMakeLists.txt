get_filename_component(REPO "${CMAKE_CURRENT_LIST_DIR}/../../.." ABSOLUTE)
set(GEN "${CMAKE_CURRENT_LIST_DIR}/../generated")
include(${GEN}/sources.cmake)
set(QJS "${REPO}/components/quickjs-ng/quickjs-ng")
set(HARNESS "${GEN}/scene.c")
if(QSKIN_BATCH)
 set(HARNESS "${GEN}/batch.c")
endif()
idf_component_register(SRCS ${SCENE_SOURCES} ${HARNESS} "${GEN}/rom.c"
 "${QJS}/dtoa.c" "${QJS}/libregexp.c" "${QJS}/libunicode.c" "${QJS}/quickjs.c" "${QJS}/quickjs-vm.c"
 INCLUDE_DIRS "${REPO}/main" "${REPO}/main/pocket" "${REPO}/main/ui" "${REPO}/main/ui/kasane" "${REPO}/main/ayatsuri" "${REPO}/main/text" "${REPO}/main/hal" "${QJS}" "${GEN}"
 REQUIRES esp_timer esp_hw_support heap esp_driver_i2c)
target_compile_definitions(${COMPONENT_LIB} PRIVATE QUICKJS_NG_BUILD _GNU_SOURCE QJS_DISABLE_DUMPS KASANE_DMA_OVERLAP=1)
target_compile_options(${COMPONENT_LIB} PRIVATE -ffp-contract=off -fno-fast-math -UNDEBUG -Wno-error -Wno-format -Wno-unused-function)
foreach(src ksn_render ksn_blend_pie ksn_shiki)
 set_source_files_properties("${REPO}/main/ui/kasane/${src}.c" PROPERTIES COMPILE_OPTIONS "-include;${CMAKE_CURRENT_LIST_DIR}/../scalar.h")
endforeach()

if(QSCENE_REPEAT_DIAGNOSTIC)
 target_compile_definitions(${COMPONENT_LIB} PRIVATE QSCENE_REPEAT_DIAGNOSTIC=1)
endif()
