"""Compile actual session dispatch and timing with deterministic owner ports."""
import ast
from pathlib import Path
import re
import subprocess
import tempfile

root = Path(__file__).resolve().parents[1]
source = (root / 'main/app_session.c').read_text()
start = source.index('static void run_pumps(uint32_t buttons) {')
end = source.index('// The half of a turn that is not JavaScript:', start)


def log_format(marker):
    """A marker's literal contract, without requiring a device or serial port."""
    match = re.search(r'ESP_LOGI\("[^"\n]+",("' + re.escape(marker) +
                      r' [^"\n]*"(?:\s*"[^"\n]*")*)', source)
    assert match, marker
    return ''.join(ast.literal_eval(s) for s in re.findall(r'"[^"\n]*"', match[1]))


# These formats predate the pump accounting fix. Fixed-position MDT readers
# and PAINT capture scripts must keep parsing the same bytes; the phase split
# belongs on its own diagnostic line instead of inserting fields in either.
assert log_format('MDT') == (
    'MDT %u %c t=%lld js=%u rn=%u sd=%u by=%u bd=%u pr=%u '
    'reg=%u/%u prep=%u/%u un=%u draw=%u/%u/%u band=%u/%u free=%u lg=%u k=%x/%x mn=%u gu=%u '
    'cv=%u/%u/%u')
assert log_format('KASANE_PAINT') == (
    'KASANE_PAINT turn_ms=%.2f render_ms=%.2f send_ms=%.2f '
    'bytes=%u bands=%u band_runs=%u band_mask=0x%05x prof=%d '
    'fill_n=%u fill_cy=%u span_n=%u span_cy=%u tile_n=%u tile_cy=%u '
    'blend_n=%u blend_cy=%u read_n=%u read_cy=%u '
    'image_n=%u image_cy=%u frames=%u')
assert log_format('MDTP') == 'MDTP %u pump=%u frame=%u cont=%u'

# The extracted reset must also be wired into the real start and the existing
# full-window boundary, with no stop-time reset that could erase final stats.
reset_start = source.index('static void reset_paint_window(void){')
reset_end = source.index('\n}\n', reset_start) + 2
app_start = source[source.index('esp_err_t app_start_test(char test) {'):
                   source.index('\nesp_err_t app_start(void)')]
assert app_start.count('reset_paint_window();') == 1
assert app_start.index('reset_paint_window();') < app_start.index('pocketjs_guest_create(')
assert source.count('reset_paint_window();') == 2
present = source[source.index('static esp_err_t present_frame(void) {'):]
assert present.index('if(painted==30)') < present.index('reset_paint_window();')

with tempfile.TemporaryDirectory(prefix='ksn-session-') as directory:
    path = Path(directory)
    (path / 'session_dispatch_impl.inc').write_text(source[start:end])
    trace_start = source.index('static struct {\n    int64_t began;')
    trace_end = source.index('} mdt;', trace_start) + len('} mdt;')
    (path / 'session_timing_trace.inc').write_text(source[trace_start:trace_end])
    (path / 'session_paint_window.inc').write_text(source[reset_start:reset_end])
    render_header = (root / 'main/ui/kasane/ksn_render.h').read_text()
    prof_start = render_header.index('typedef struct {\n    uint32_t fill_cy,')
    prof_end = render_header.index('} ksn_render_prof;', prof_start) + len('} ksn_render_prof;')
    (path / 'session_paint_prof.inc').write_text(render_header[prof_start:prof_end])
    for flags in (['-O1', '-g', '-fsanitize=address,undefined'], ['-O2', '-fstrict-aliasing']):
        for filename, defines in (
                ('test_session_dispatch.c', []),
                ('test_session_paint_window.c', []),
                ('test_session_paint_window.c', ['-DKASANE_STRESS_GRAD_AB=1']),
                ('test_session_timing.c', []),
                ('test_session_timing.c', ['-DKASANE_MEGADEMO_TRACE',
                                           '-DCONFIG_POCKET_VM_PROBE',
                                           '-DCONFIG_POCKET_VM_TURNPERF'])):
            exe = path / 'test'
            subprocess.run(['gcc', '-std=c11', '-Wall', '-Wextra', '-Werror',
                            *flags, *defines, '-I', str(path),
                            str(root / 'tools' / filename), '-o', str(exe)], check=True)
            subprocess.run([str(exe)], check=True)
