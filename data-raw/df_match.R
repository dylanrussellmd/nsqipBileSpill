df_match <- df %>%
  dplyr::select(spill, supinfec, wndinfd, orgspcssi, dindo_min, dindo_maj, mort, tothlos, sex, age, bmi, diabetes, insulin, smoke, dyspnea, preopindependent, hxcopd, ascites, hxchf, hypermed, dialysis, discancr, steroid, wtloss, bleeddis, optime, ioc) %>%
  MatchIt::matchit(spill ~ sex + age + bmi + diabetes + insulin + smoke + dyspnea + preopindependent + hxcopd + ascites + hxchf + hypermed + dialysis + discancr + steroid + wtloss + bleeddis + optime + ioc, data = ., method = "nearest", ratio = 2) %>% MatchIt::match.data() %>%
  nsqipBileSpill::assign_labels()

 usethis::use_data(df_match, overwrite = TRUE)
