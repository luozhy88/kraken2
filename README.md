# kraken2

## 安装
conda create -n kraken2 -c conda-forge -c bioconda -c defaults kraken2 bracken  
#https://hackmd.io/@astrobiomike/kraken2-bracken-standard-build  
#https://github.com/jenniferlu717/KrakenTools  
conda activate krakn2 #31 sunjialv  

## Downloading and building reference database

kraken2-build --standard --db kraken2-standard-db/ --threads 42  
kraken2-build --clean --db kraken2-standard-db/  








## ERROR
Kraken2: "rsync_from_ncbi.pl: unexpected FTP path (new server?) for https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/900/128/725/GCF_900128725.1_B  

For those who are working with conda and facing this problem:
go to the anaconda folder --->then go to the folder where you installed Kraken ---->libexec----->rsync_from_ncbi.pl---->modify line 46 : https in place of ftp .... then run the command.
It works well for me !  
