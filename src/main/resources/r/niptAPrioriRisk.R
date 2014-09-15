# load functions
source('nipt.R')

#` load table
tab = get.table("T${chrom}risk.txt")

library(rjson)
cat(toJSON(list(aPriori = aPrioriRisk(tab, ${gaw}, ${gad}, ${may}, ${mam}), chrom = ${chrom}, gaw = ${gaw}, gad = ${gad}, may = ${may}, mam = ${mam})))