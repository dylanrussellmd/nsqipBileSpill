con <- DBI::dbConnect(
  bigrquery::bigquery(),
  project = "numeric-pilot-279119",
  dataset = "nsqip"
)

sql <- 'SELECT caseid, pufyear, cpt, sex, age, height, weight, diabetes, insulin, smoke, dyspnea, when_dyspnea, fnstatus2, hxcopd, ascites, hxchf,
hypermed, dialysis, discancr, steroid, wtloss, bleeddis, wndclas, IF(wndclas IN (3, 4), TRUE, FALSE) as spill, optime, supinfec, wndinfd, orgspcssi, yrdeath, tothlos, dehis, oupneumo, reintub, pulembol, failwean, renainsf, oprenafl, urninfec, cnscva, cdarrest, cdmi, othbleed, othdvt, othsysep, othseshock, returnor, readmission1, podiag, podiag10
FROM puf
WHERE inout = false AND transt = 2 AND electsurg = true AND ventilat = false AND ventpatos = false AND asaclas < 5 AND optime > 15 AND optime < 240
 AND surgspec = 2 AND prsepis = false AND renafail = false AND wndinf = false AND transfus = false AND (chemo = false OR chemo IS NULL)
 AND age >= 18 AND otherproc1 IS NULL AND concurr1 IS NULL AND cpt IN ("47562","47563") and (STARTS_WITH(podiag, "575.") is false or STARTS_WITH(podiag, "575.") is null) and (STARTS_WITH(podiag10, "k81.") is false or STARTS_WITH(podiag10, "k81.") is null)'


df <- DBI::dbGetQuery(con, sql) %>%
  assign_labels() %>%
  add_dindo_group() %>%
  dplyr::mutate(mort = dindo == 5) %>%
  add_bmi() %>%
  add_preopindependent() %>%
  dplyr::mutate(ioc = cpt == 47563) %>%
  remove_missing(spill, supinfec, wndinfd, orgspcssi, dindo, dindo_min, dindo_maj, mort, tothlos, ioc, sex, age, bmi, diabetes, insulin, smoke, dyspnea, preopindependent, hxcopd, ascites, hxchf, hypermed, dialysis, discancr, steroid, wtloss, bleeddis, optime)


#Hmisc::label(df$mort) <- "Death within 30 days"
#Hmisc::label(df$ioc) <- "Intraoperative cholangiogram"

usethis::use_data(df, overwrite = TRUE)
