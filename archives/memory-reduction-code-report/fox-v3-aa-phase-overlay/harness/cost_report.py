"""Use the storage-v3 evidence aggregator, not historical row-upgrade accounting."""
from pathlib import Path
import runpy
runpy.run_path(str(Path(__file__).with_name('report_exact_capacity.py')),run_name='__main__')
