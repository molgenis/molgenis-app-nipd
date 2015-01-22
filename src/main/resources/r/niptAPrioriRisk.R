# TODO: replace following line by
#		source(fromJSON(paste0(readLines(curl( 'http://localhost:8080/api/vi/scripts/nipt'  ))))$content)
source('http://localhost:8080/scripts/nipt/run')

# set file store as work dir
setwd('~/.molgenis/nipd/data/filestore')

#` load table
tab = get.table("T${chrom}risk.txt")

if (! "rjson" %in% rownames(installed.packages(lib.loc='.'))) install.packages('rjson', lib='.', repos="http://cran.us.r-project.org")
library(rjson, lib.loc='.')
cat(toJSON(list(aPriori = aPrioriRisk(tab, ${gaw}, ${gad}, ${may}, ${mam}), chrom = ${chrom}, gaw = ${gaw}, gad = ${gad}, may = ${may}, mam = ${mam})))