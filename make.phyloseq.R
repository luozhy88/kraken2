

print("working dir: output")

library(dplyr)
library(ShortRead)
library(phyloseq)
library(microbiome)
library(seqinr)
library(metagMisc)
###############
library(Biostrings)
library(RDPutils)
dir.create("phyloseq")


kraken_df<-read.csv("output/kraken2_all.report",sep="\t",header = TRUE)
colnames(kraken_df)[1]<-"Tax"
kraken_df<-kraken_df %>%  dplyr::filter(grepl("s__",Tax))


reform<-function(str_){
  # print(str_)
  str_split<- strsplit(str_,"\\|") %>% unlist()
  if(grepl("k__",str_)==FALSE){Kingdom="k__"}else{Kingdom=str_split[grep("k__",str_split)][1] }
  if(grepl("p__",str_)==FALSE){Phylum="p__"}else{Phylum=str_split[grep("p__",str_split)]}
  if(grepl("c__",str_)==FALSE){Class="c__"}else{Class=str_split[grep("c__",str_split)]}
  if(grepl("o__",str_)==FALSE){Order="o__"}else{Order=str_split[grep("o__",str_split)]}
  if(grepl("f__",str_)==FALSE){Family="f__"}else{Family=str_split[grep("f__",str_split)]}
  if(grepl("g__",str_)==FALSE){Genus="g__"}else{Genus=str_split[grep("g__",str_split)]}
  if(grepl("s__",str_)==FALSE){Species="s__"}else{Species=str_split[grep("s__",str_split)]}
  merge_str<-paste(Kingdom,Phylum,Class,Order,Family,Genus,Species,sep  = "|")
  # print(merge_str)
  return(merge_str)
}
kraken_df$Tax<-purrr::map(kraken_df$Tax,reform) %>% unlist()



kraken_df_tax2<-kraken_df %>% tidyr::separate(Tax, into = c("Kingdom", "Phylum", "Class", "Order", "Family", "Genus","Species"), sep = "\\|") #????
kraken_df_tax2[,1:7]<-apply(kraken_df_tax2[,1:7], 2, function(x){ gsub(".__","",x)}) %>% data.frame()
rownames(kraken_df_tax2)<-paste0("H",rownames(kraken_df_tax2))

# rep.seqs <- Biostrings::readDNAStringSet("results/01.PJ_mergedv2.fasta", format = "fasta")


kraken_df_otu_table<-kraken_df_tax2[,-c(1:7)]
kraken_df_tax_table<-kraken_df_tax2[,1:7]
phyloseq_<-phyloseq(otu_table(kraken_df_otu_table,taxa_are_rows = T),tax_table( kraken_df_tax_table%>% as.matrix())  )


# phyloseq_<-phyloseq(otu_table(kraken_df_otu,taxa_are_rows = T),tax_table( kraken_df_tax3%>% as.matrix()) ,rep.seqs)
# phyloseq <- prune_taxa(taxa_sums(phyloseq) > 0, phyloseq)
p023_core <- core(phyloseq_, detection = 0.0005, prevalence = 0)
p023_core
saveRDS(phyloseq_,"phyloseq/shotgun_phyloseq.rds" ) #save all_phyloseq


