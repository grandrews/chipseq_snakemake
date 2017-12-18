shell.prefix("set -eo pipefail; ")

configfile: "config.yaml"
localrules: all
import glob

SAMPLES = glob.glob('samples/*.fastq.gz')
SAMPLES = [sample.replace('.fastq.gz','') for sample in SAMPLES]
SAMPLES = [sample.replace('samples/','') for sample in SAMPLES]



ALL_FASTQ = expand("samples/{sample}.fastq.gz", sample=SAMPLES)
ALL_FINAL_BAM = expand("mapped_reads/{sample}.final.bam", sample=SAMPLES)
ALL_BED = expand("bed_files/{sample}.bed.gz", sample=SAMPLES)
CC_SCORE = expand("xcor/{sample}.cc", sample=SAMPLES)
ALL_NARROW_PEAK = expand("peaks/{sample}.narrowPeak.gz", sample=SAMPLES)
ALL_BROAD_PEAK = expand("peaks/{sample}.broadPeak.gz", sample=SAMPLES)

rule all:
    input: 
        ALL_BED + CC_SCORE + ALL_BROAD_PEAK
    

if config["paired"]:
    include: "modules/map_pe"
    include: "modules/filter_pe"
    #include: "modules/xcor_pe"
    #include: "modules/pseudorep_pe"
    #include: "modules/callpeaks_pooled"
    #include: "modules/callpeaks_tr"
    #include: "modules/callpeaks_pooledpr"
    #include: "modules/overlap"

else:
    include: "modules/trim_se"
    include: "modules/map_se"
    include: "modules/filter_se"
    include: "modules/xcor_se"
    include: "modules/peakcalling_se"