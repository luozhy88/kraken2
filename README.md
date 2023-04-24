# kraken2

## 安装
conda create -n kraken2 -c conda-forge -c bioconda -c defaults kraken2 bracken  
#https://hackmd.io/@astrobiomike/kraken2-bracken-standard-build  
#https://github.com/jenniferlu717/KrakenTools  
conda activate krakn2 #31 sunjialv  

## Downloading and building reference database

kraken2-build --standard --db kraken2-standard-db/ --threads 42  
kraken2-build --clean --db kraken2-standard-db/  
