# TODO: replace following line by
#		source(fromJSON(paste0(readLines(curl( 'http://localhost:8080/api/vi/scripts/nipt'  ))))$content)
source('http://localhost:8080/scripts/nipt/run')

# compute risk
if (! "rjson" %in% rownames(installed.packages(lib.loc='.'))) install.packages('rjson', lib='.', repos="http://cran.us.r-project.org")
library(rjson, lib.loc='.')
cat(toJSON(list(risk = risk(${lower}, ${upper}, ${varcof}, ${z}, ${aPriori}), lower = ${lower}, upper = ${upper}, varcof = ${varcof}, z = ${z}, aPriori = ${aPriori})))