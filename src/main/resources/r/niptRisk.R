# TODO: replace following line by
#		source(fromJSON(paste0(readLines(curl( 'http://localhost:8080/api/vi/scripts/nipt'  ))))$content)
source('http://localhost:8080/scripts/nipt/run')

# compute risk
library(rjson)
cat(toJSON(list(risk = risk(${lower}, ${upper}, ${varcof}, ${z}, ${aPriori}), lower = ${lower}, upper = ${upper}, varcof = ${varcof}, z = ${z}, aPriori = ${aPriori})))