#!/bin/bash
#SBATCH --partition=highmem_p
#SBATCH --job-name=run_max
#SBATCH --ntasks=1                      
#SBATCH --cpus-per-task=12           
#SBATCH --time=128:00:00
#SBATCH --mem=200G
#SBATCH --output=%x.%j.out       
#SBATCH --error=%x.%j.out        
#SBATCH --mail-user=rx32940@uga.edu
#SBATCH --mail-type=ALL


#conda create -n kraken2 kraken2=2.1.2
source activate kraken2.2 # v2.1.2
################################################################


DBNAME="/data/zhiyu/save_220T_user/zhiyu/Database/kraken2/kraken2-standard-db/db"
OUT="/data/zhiyu/save_220T_user/zhiyu/ncbi_data/metagenomic/SRP373424/kraken2/output"
INPUT="/data/zhiyu/save_220T_user/zhiyu/ncbi_data/metagenomic/SRP373424/rm_host/test"

mkdir -p $OUT
mkdir -p $OUT/sbatch
rm sbatch_kraken2.sh

for file in $INPUT/*_1.filtered.fastq.gz;
do

sample=$(basename $file '_1.filtered.fastq.gz')
echo $sample;


# form biom conversion
echo "

source activate kraken2.2
time kraken2 -db $DBNAME --threads 12 \
--report $OUT/$sample.report --output $OUT/$sample.out \
--paired $INPUT/${sample}_1.filtered.fastq.gz $INPUT/${sample}_2.filtered.fastq.gz 

# echo 'finished!' | s-nail -s $sample 479321347@qq.com

time bracken  -d $DBNAME  -i $OUT/$sample.report  -o bracken2 -w $OUT/$sample.bracken.report -r 150 -l S

time script/kreport2mpa.py -r $OUT/$sample.bracken.report   -o $OUT/$sample.bracken.mpa.report

#conda deactivate

" > output/sbatch/sbatch_$sample.sh

done
mkdir output

ls output/sbatch/sbatch_*.sh |parallel -j 30 sh {} ">" {.}.log
################################################################
# 2) combine reports for each sample
# use krakenTools (available in the kraken2 conda env)
################################################################

script/combine_mpa.py -i $(echo $OUT/*mpa.report) -o $OUT/kraken2_all.report

echo 'finished!' | s-nail -s 'kraken2 all_SAMPLE' 479321347@qq.com


#kraken-biom $OUT/*.report -o $OUT/../kraken2.max.biom --fmt json # convert kraken2 report to biom format


conda deactivate





