import subprocess
from statistics import stdev
import sys
import os

" Globals: "
ext4_mount_options = ("journal", "ordered", "writeback")
personality_options = ("fileserver", "oltp", "randomread", "randomwrite", "singlestreamread", "singlestreamwrite",
                       "varmail", "videoserver", "webproxy", "webserver")

def get_throughput():
    with open('/tmp/results', 'r') as res_file:
          line = res_file.readlines()
          for i in line:
              split_line = i.split()
              if "Summary:" in split_line:
                  for j in split_line:
                      if j[-4:] == "mb/s":
                          return j

def printStatistics(runs, final_metric_conf_interval, final_metric_stdev, final_metric_mean, chosenMetricList, throughput):
    print("\n" * 1)
    print("------------------- Statistics for metric '" + sys.argv[1] + "' -------------------")
    print("Number of runs: {}\n".format(runs))
    print("95% confidence interval = {}\n".format(round(final_metric_conf_interval, 5)))
    print("Standard deviation = {}\n".format(round(final_metric_stdev, 5)))
    print("Mean = {}\n".format(round(final_metric_mean), 5))
    print("Sample list: {}\n".format(chosenMetricList))
    print("Throughput = {}".format(throughput))
    print("-----------------------------------------------------------------------")
    print("\n" * 1)


def printScriptSyntax():
    print("\n" * 1)
    print("Experiment script's syntax:\npython3 experiment.py <metric> <filebench personality>")
    print("\n<metric> = {usr_avg, sys_avg, iostat_avg, free, inact, active, tps, kB_read_rate, "
           "kB_write_rate, kB_read, kB_wrtn}")
    print("\n<filebench personality> = {fileserver, oltp, randomread, randomwrite, singlestreamread, "
           "singlestreamwrite, varmail, videoserver, webproxy, webserver}")
    print("\n" * 1)
    sys.exit(1)

def calculate_95_conf_interval(sample_list):
    conf_interval_95 = (1.96 * stdev(sample_list)) / (len(sample_list)**(0.5))
    return conf_interval_95


def call_mpstat(outfile_path, mpstat_options):
    with open(outfile_path, "w") as outfile:
        subprocess.run(["mpstat", mpstat_options[0], mpstat_options[1], mpstat_options[2],
                        mpstat_options[3]], stdout=outfile)


def call_iostat(outfile_path, iostat_options):
    with open(outfile_path, "w") as outfile:
        subprocess.run(["iostat", iostat_options[0], iostat_options[1]], stdout=outfile)


def call_vmstat(outfile_path, vmstat_options):
    with open(outfile_path, "w") as outfile:
        subprocess.run(["vmstat", "-a"], stdout=outfile)


def call_filebench(outfile_path, personality_name):
    with open(outfile_path, "w") as outfile:
        subprocess.run(["filebench", "-f", "/root/workloads/" + personality_name + ".f", ">"], stdout=outfile)


def read_mpstat_results(cpu_usr_avg, cpu_sys_avg, cpu_iostat_avg):
    with open('/tmp/mpstat.out', 'r') as mp_file:
        mpstat_line24 = mp_file.readlines()[23].split()
        cpu_usr_avg.append(float(mpstat_line24[2]))
        cpu_sys_avg.append(float(mpstat_line24[4]))
        cpu_iostat_avg.append(float(mpstat_line24[5]))

        return (cpu_usr_avg, cpu_sys_avg, cpu_iostat_avg)


def read_vmstat_results(mem_free, mem_inact, mem_active):
    with open('/tmp/vmstat.out', 'r') as vm_file:
        vmstat_line3 = vm_file.readlines()[2].split()
        mem_free.append(int(vmstat_line3[3]))
        mem_inact.append(int(vmstat_line3[4]))
        mem_active.append(int(vmstat_line3[5]))

        return (mem_free, mem_inact, mem_active)

def read_iostat_results(io_tps, io_kB_read_rate, io_kB_write_rate, io_kB_read, io_kB_written):
    with open('/tmp/iostat.out', 'r') as io_file:
        iostat_line4 = io_file.readlines()[3].split()

        io_tps.append(float(iostat_line4[1]))
        io_kB_read_rate.append(float(iostat_line4[2]))
        io_kB_write_rate.append(float(iostat_line4[3]))
        io_kB_read.append(int(iostat_line4[5]))
        io_kB_written.append(int(iostat_line4[6]))

        return (io_tps, io_kB_read_rate, io_kB_write_rate, io_kB_read, io_kB_written)

def runExperiment():
    runs = 0  # experiment repetitions
    alpha = 0.05  # confidence interval
    need_more_runs = True
    ext4_journal = ""

    mpstat_options = ("-P", "ALL", "2", "5")
    iostat_options = ("-d", "sda3")
    vmstat_options = ("-a")

    # cpu-related metrics
    cpu_usr_avg = []
    cpu_sys_avg = []
    cpu_iostat_avg = []

    # memory-related metrics
    mem_free = []
    mem_inact = []
    mem_active = []

    # persistent-related metrics
    io_tps = []
    io_kB_read_rate = []
    io_kB_write_rate = []
    io_kB_read = []
    io_kB_written = []

    chosenMetricList = []

    try:
        if sys.argv[1] == "usr_avg":
            chosenMetricList = cpu_usr_avg
        elif sys.argv[1] == "sys_avg":
            chosenMetricList = cpu_sys_avg
        elif sys.argv[1] == "iostat_avg":
            chosenMetricList = cpu_iostat_avg
        elif sys.argv[1] == "free":
            chosenMetricList = mem_free
        elif sys.argv[1] == "inact":
            chosenMetricList = mem_inact
        elif sys.argv[1] == "active":
            chosenMetricList = mem_active
        elif sys.argv[1] == "tps":
            chosenMetricList = io_tps
        elif sys.argv[1] == "kB_read_rate":
            chosenMetricList = io_kB_read_rate
        elif sys.argv[1] == "kB_write_rate":
            chosenMetricList = io_kB_write_rate
        elif sys.argv[1] == "kB_read":
            chosenMetricList = io_kB_read
        elif sys.argv[1] == "kB_wrtn":
            chosenMetricList = io_kB_written
        else:
            sys.exit("Metrics list: <usr_avg, sys_avg, iostat_avg, free, inact, active, tps, "
                    "kB_read_rate, kB_write_rate, kB_read, kB_wrtn>")
    except IndexError:
        printScriptSyntax()

    try:
        if sys.argv[2] in personality_options:
            chosen_personality = sys.argv[2]
        else:
            sys.exit("Personlaity options: <fileserver, oltp, randomread, randomwrite, singlestreamread, singlestreamwrite, "
                 "varmail, videoserver, webproxy, webserver>")
    except IndexError:
        printScriptSyntax()


    while need_more_runs and runs < 10:
        os.system("/bin/bash /root/scripts/start-disk.sh ext4-" + ext4_mount_options[0])
        # subprocess.call(["/root/scripts/start-disk.sh", " ext4-" + ext4_mount_options[0]])
        # Start a clean filesystem

        call_mpstat('/tmp/mpstat.out', mpstat_options)
        call_iostat('/tmp/iostat.out', iostat_options)
        call_vmstat('/tmp/vmstat.out', vmstat_options)

        # free slab objects and page cache
        with open('/proc/sys/vm/drop_caches', "w") as outfile:
            subprocess.run(["echo", "3"], stdout=outfile)

        # execute filebench personality
        call_filebench('/tmp/results', chosen_personality)
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
        iostat_results_tuple = read_iostat_results(io_tps, io_kB_read_rate, io_kB_write_rate,
                                                   io_kB_read, io_kB_written)
        io_tps = iostat_results_tuple[0]
        io_kB_read_rate = iostat_results_tuple[1]
        io_kB_write_rate = iostat_results_tuple[2]
        io_kB_read = iostat_results_tuple[3]
        io_kB_written = iostat_results_tuple[4]

        runs += 1
        if runs > 1:
            conf_interval = calculate_95_conf_interval(chosenMetricList)
            mean = sum(chosenMetricList) / len(chosenMetricList)
            # printStatistics(runs, conf_interval, stdev(chosenMetricList), mean, chosenMetricList, get_throughput())
            if (conf_interval / mean) < alpha:
                need_more_runs = False
        os.system("/bin/bash /root/scripts/stop-disk.sh")
        # subprocess.call(["/bin/bash", "/root/scripts/stop-disk.sh"])

    tput = get_throughput()
    standard_dev = stdev(chosenMetricList)
    os.system("clear")
    printStatistics(runs, conf_interval, standard_dev, mean,
                    chosenMetricList, tput)

    os.system("/bin/bash /root/Desktop/stats.sh " + chosen_personality + ".f " + str(round(conf_interval, 5)) + " " +
    str(round(standard_dev, 5)) + " " + str(round(mean, 5)) + " " + str(round(float(tput[:len(tput)-4]), 5)))


if __name__ == "__main__":
    os.system("/bin/bash /root/scripts/stop-disk.sh")
    runExperiment()
