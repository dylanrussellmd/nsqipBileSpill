
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Intraoperative Bile Spillage as a Risk Factor for Surgical Site Infection - A Large NSQIP Database Analysis

<!-- badges: start -->

[![R build
status](https://github.com/dylanrussellmd/nsqipBileSpill/workflows/R-CMD-check/badge.svg)](https://github.com/dylanrussellmd/nsqipBileSpill/actions)
<!-- badges: end -->

This is a propensity score matched analysis of bile spillage as it
relates to rates of surgical site infection, minor and major
complications, and total hospital length of stay using the NSQIP
database.

## Installation and Use

You can install the latest version of nsqipBileSpill from
[GitHub](https://github.com/dylanrussellmd/nsqipBileSpill) with:

``` r
# install.packages("devtools")
devtools::install_github("dylanrussellmd/nsqipBileSpill")
```

If you would like copies of the data used to run this analysis, please
contact [the author](mailto:dyl.russell@gmail.com) directly.

### Introduction

Laparoscopic cholecystectomy (LC) is one of the most commonly performed
operations in the United States. Surgical site infection complicates
1-2% of these operations and can be associated with significant
morbidity. Bile spillage (bile spillage) occurs in many of these
operations. The associated risk of surgical site infection (SSI) is an
ongoing area of research.

### Methods

NSQIP registries between 2005 and 2018 were queried using *Current
Procedural Terminology* codes 47562 and 47563 to identify patients
undergoing elective laparoscopic cholecystectomy. Patients were
considered to have bile spillage if the wound classification was
annotated 3 or 4. Acute cholecystitis was excluded by ICD code. Patients
were propensity scored for bile spillage and matched for pre-operative
risk factors. The rates of surgical site infections, morbidity, and
mortality and length of stay were analyzed.

### Results

47,919 (31,946 with no spillage and 15,973 with spillage) patients were
matched and included in the analysis. After matching, no significant
difference was found in superficial or deep SSI regardless of bile
spillage. An absolute increase in organ-space SSI of 0.32% was detected.
The group with bile spillage had small increases in both minor (1.41%
vs. 2.12%; *p* = \<0.01) and major (0.67% vs. 1.01%; *p* = \<0.01)
complications. There was no difference in mortality.

### Conclusion

This retrospective database review demonstrates a very small association
between BS and organ-space infections. It is unclear if routine
antibiotic prophylaxis or post-exposure antibiotic treatment of bile
spillage is necessary given the small clinical impact of BS.
