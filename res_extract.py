import os
import csv
RUN_DIR =  "/home/local/nu/shg/systolic_tlv/runs"
OUTPUT_CSV = "synth_results_extract.csv"
area_rpt = "log/area.rpt"
power_rpt = "log/reportpower.rpt"

def extract_configs(path):
    empty = {
        "config":"",
        "area":"",
        "totalpower":"",
        "cell_count":"",
    }
    with open(OUTPUT_CSV, 'w', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=empty.keys())
        writer.writeheader()

    subdirs = [os.path.join(path, d) for d in os.listdir(path) if d.startswith("run_")]
    sub_dirs = []

    for i in subdirs:
        for j in os.listdir(i):
            if os.path.isdir(os.path.join(i,j)):
                sub_dirs.append(os.path.join(i,j))
    print(sub_dirs)

    for i in sub_dirs:
        _i = i.split("/")
        _config = ""
        for item in _i:
            if item.startswith("run"):
                _config = item
        _area = ""
        _tot_power = ""
        _cell_count = ""
        with open(os.path.join(i,area_rpt),"r") as f:
            for line in f:
                if "Total cell area: " in line:
                    _area = line.split(":")[-1].strip()
                if "Number of combinational cells:" in line:
                    _cell_count = line.split(":")[-1].strip()
        
        with open(os.path.join(i,power_rpt),"r") as f:
            for line in f:
                if "Total" in line:
                    _tot_power = line.split(" ")[-2].strip()
        
        data = {
                "config":_config,
                "area":_area,
                "totalpower":_tot_power,
                "cell_count":_cell_count,
    }
        with open(OUTPUT_CSV, 'a', newline='') as f:
                        writer = csv.DictWriter(f, fieldnames=data.keys())
                        writer.writerow(data)
        print(data)
        



    

if __name__ == "__main__":
    extract_configs(RUN_DIR)


