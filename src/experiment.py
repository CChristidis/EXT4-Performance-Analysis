import subprocess


" Globals: "
ext4_mount_options = ("journaled", "ordered", "writeback")
personality_options = ("fileserver", "oltp", "randomread", "randomwrite", "singlestreamread", "singlestreamwrite",
                       "varmail", "videoserver", "webproxy", "webserver")


def call_mpstat(outfile_path, mpstat_options):
    with open(outfile_path, "w") as outfile:
        subprocess.run(["mpstat", mpstat_options[0], mpstat_options[1]], stdout=outfile)


def call_iostat(outfile_path, iostat_options):
    with open(outfile_path, "w") as outfile:
        subprocess.run(["iostat", iostat_options[0], iostat_options[1]], stdout=outfile)


def call_vmstat(outfile_path, vmstat_options):
    with open(outfile_path, "w") as outfile:
        subprocess.run(["vmstat", "-a"], stdout=outfile)


def call_filebench(outfile_path, personality_name):
    with open(outfile_path, "w") as outfile:
        subprocess.run(["filebench", "-f", "/root/workloads/" + personality_name + ".f"], stdout=outfile)


def runExperiment():
    runs = 0  # experiment repetitions
    alpha = 0.05  # confidence interval
    need_more_runs = True
    ext4_journal = ""

    mpstat_options = ("-P", "ALL")
    iostat_options = ("-d", "sda3")
    vmstat_options = ("-a")

    while need_more_runs:
        # Start a clean filesystem
        subprocess.call(["sh", "/root/scripts/start-disk.sh", " ext4-$ " + ext4_mount_options[0]])
        call_mpstat('/tmp/mpstat.out', mpstat_options)
        call_iostat('/tmp/iostat.out', iostat_options)
        call_vmstat('/tmp/vmstat.out', vmstat_options)

        # free slab objects and page cache
        with open('/proc/sys/vm/drop_caches', "w") as outfile:
            subprocess.run(["echo", "3"], stdout=outfile)

        call_filebench('/tmp/results', personality_options[1])

        runs += 1

        need_more_runs = False;


if __name__ == "__main__":
    runExperiment()


