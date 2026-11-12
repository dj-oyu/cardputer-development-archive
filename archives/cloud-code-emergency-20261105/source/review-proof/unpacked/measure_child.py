import subprocess,sys,resource,pathlib
run=subprocess.run(sys.argv[2:])
pathlib.Path(sys.argv[1]).write_text(str(resource.getrusage(resource.RUSAGE_CHILDREN).ru_maxrss))
raise SystemExit(run.returncode)
