import sys
import os
import re

def get_lines(path: str):
	file = [line for line in open(path, 'r')]
	lines = [line.split() for line in file]
	return lines


def clear_unwanted_lines(lines_list):
	lines = [elem[1:] for idx, elem in enumerate(lines_list) if len(elem) > 0 and elem[1] != "seconds"
			 and elem[0] not in ('mke2fs', 'Performance')]
	return lines

def get_perfstat_numbers(lines):
	results = []
	for line in lines:
		num = line[line.index('#') + 1]
		num = re.sub("[^0-9^.]", "", num)
		results.append(num)
	return results
	#

def to_str(results):
	results_str =  ", ".join(results)
	return results_str



def main(*args):
	os.system("clear")
	lines = get_lines("perf_stat_results.txt")
	lines = clear_unwanted_lines(lines)
	results = get_perfstat_numbers(lines)
	results_str = to_str(results)
	# print("sed ' 1 s/.*/&, " + results_str + "/' experiment_stats.txt")
	os.system("sed ' $ s/.*/&, " + results_str + "/' experiment_stats_temp.txt >> experiment_stats.txt")



if __name__ == "__main__":
    main(sys.argv[1:])
