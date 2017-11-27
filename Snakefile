shell.prefix("set -eo pipefail; ")

configfile: "config.yaml"
localrules: all

IPS = config["ips"]
ALL_SAMPLES = config["ips"] + config["controls"]
ALL_FINAL_BAM = expand("mapped_reads/{sample}.final.bam", sample=ALL_SAMPLES)
ALL_BED = expand("bed_files/{sample}.bed.gz", sample=ALL_SAMPLES)
CC_SCORE = expand("xcor/{sample}.cc_score", sample=ALL_SAMPLES)

rule all:
    input: ALL_FINAL_BAM + ALL_BED

if config["paired"]:
    include: "modules/map_pe"
    include: "modules/filter_pe"
    include: "modules/xcor_pe"
    include: "modules/pseudorep_pe"
    include: "modules/callpeaks_pooled"
    include: "modules/callpeaks_tr"
    include: "modules/callpeaks_pooledpr"
    include: "modules/overlap"

else:
    include: "modules/trim_se"
    include: "modules/map_se"
    include: "modules/filter_se"
    include: "modules/xcor_se"
    include: "modules/pseudorep_se"
    include: "modules/callpeaks_tr"
    include: "modules/callpeaks_pooled"
    include: "modules/callpeaks_pooledpr"
    include: "modules/overlap"
