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


def read_mpstat_results(cpu_usr_avg, cpu_sys_avg, cpu_iostat_avg):
    with open('/tmp/mpstat.out', 'r') as mp_file:
        mpstat_line4 = mp_file.readlines()[3].split()
        cpu_usr_avg += float(mpstat_line4[3])
        cpu_sys_avg += float(mpstat_line4[5])
        cpu_iostat_avg += float(mpstat_line4[6])

        return (cpu_usr_avg, cpu_sys_avg, cpu_iostat_avg)


def read_vmstat_results(mem_free, mem_inact, mem_active):
    with open('/tmp/vmstat.out', 'r') as vm_file:
        vmstat_line3 = vm_file.readlines()[2].split()
        mem_free += int(vmstat_line3[3])
        mem_inact += int(vmstat_line3[4])
        mem_active += int(vmstat_line3[5])

        return (mem_free, mem_inact, mem_active)

def read_iostat_results(io_tps, io_kB_read_rate, io_kB_write_rate, io_kB_read, io_kB_written):
    with open('/tmp/iostat.out', 'r') as io_file:
        iostat_line4 = io_file.readlines()[3].split()

        io_tps += float(iostat_line4[1])
        io_kB_read_rate += float(iostat_line4[2])
        io_kB_write_rate += float(iostat_line4[3])
        io_kB_read += int(iostat_line4[5])
        io_kB_written += int(iostat_line4[6])

        return (io_tps, io_kB_read_rate, io_kB_write_rate, io_kB_read, io_kB_written)

def runExperiment():
    runs = 0  # experiment repetitions
    alpha = 0.05  # confidence interval
    need_more_runs = True
    ext4_journal = ""

    mpstat_options = ("-P", "ALL")
    iostat_options = ("-d", "sda3")
    vmstat_options = ("-a")

    # cpu-related metrics
    cpu_usr_avg = 0
    cpu_sys_avg = 0
    cpu_iostat_avg = 0

    # memory-related metrics
    mem_free = 0
    mem_inact = 0
    mem_active = 0

    # persistent-related metrics
    io_tps = 0
    io_kB_read_rate = 0
    io_kB_write_rate = 0
    io_kB_read = 0
    io_kB_written = 0


    while need_more_runs:
        # Start a clean filesystem
        subprocess.call(["sh", "/root/scripts/start-disk.sh", " ext4-$ " + ext4_mount_options[0]])
        call_mpstat('/tmp/mpstat.out', mpstat_options)
        call_iostat('/tmp/iostat.out', iostat_options)
        call_vmstat('/tmp/vmstat.out', vmstat_options)

        # free slab objects and page cache
        with open('/proc/sys/vm/drop_caches', "w") as outfile:
            subprocess.run(["echo", "3"], stdout=outfile)

        # execute oltp.f
        call_filebench('/tmp/results', personality_options[1])

        # update mpstat result variables
        mpstat_results_tuple = read_mpstat_results(cpu_usr_avg, cpu_sys_avg, cpu_iostat_avg)
        cpu_usr_avg = mpstat_results_tuple[0]
        cpu_sys_avg = mpstat_results_tuple[1]
        cpu_iostat_avg = mpstat_results_tuple[2]

        # update vmstat result variables
        vmstat_results_tuple = read_vmstat_results(mem_free, mem_inact, mem_active)
        mem_free = vmstat_results_tuple[0]
        mem_inact = vmstat_results_tuple[1]
        mem_active = vmstat_results_tuple[2]



        # update iostat result variables
        iostat_results_tuple = read_iostat_results(io_tps, io_kB_read_rate, io_kB_write_rate, io_kB_read, io_kB_written)
        io_tps = iostat_results_tuple[0]
        io_kB_read_rate = iostat_results_tuple[1]
        io_kB_write_rate = iostat_results_tuple[2]
        io_kB_read = iostat_results_tuple[3]
        io_kB_written = iostat_results_tuple[4]

        print(cpu_usr_avg, cpu_sys_avg, cpu_iostat_avg)
        print(mem_free, mem_inact, mem_active)
        print(io_tps, io_kB_read_rate, io_kB_write_rate, io_kB_read, io_kB_written)

        runs += 1

        need_more_runs = False;


if __name__ == "__main__":
    runExperiment()


