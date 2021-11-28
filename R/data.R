#' Elective laparoscopic cholecystectomies from NSQIP Registry
#'
#' A dataset containing 127,228 records of elective laparoscopic cholecystectomies from the NSQIP registry.
#' This data has been previously cleaned using the `nsqipr` package and stored in Google BigQuery.
#'
#' @format A data frame with 127,228 rows and 56 variables:
#' \describe{
#'  \item{caseid}{Case identification number}
#'  \item{pufyear}{NSQIP PUF year from which the record was collected}
#'  \item{cpt}{CPT code indicating procedure performed}
#'  \item{sex}{Logical, TRUE for male, FALSE for female}
#'  \item{age}{Age in years}
#'  \item{height}{Height in inches}
#'  \item{weight}{Weight in pounds}
#'  \item{bmi}{BMI of patient in kg/m^2}
#'  \item{diabetes}{Diabetes mellitus with oral agents or insulin}
#'  \item{insulin}{Insulin dependent diabetes mellitus}
#'  \item{smoke}{Current smoker within 1 year}
#'  \item{dyspnea}{Presence of dypsnea}
#'  \item{when_dyspnea}{When dyspnea is present}
#'  \item{fnstatus2}{Functional health status prior to surgery}
#'  \item{preopindependent}{Functionally independent prior to surgery}
#'  \item{hxcopd}{History of severe COPD}
#'  \item{ascites}{Ascites within 30 days prior to surgery}
#'  \item{hxchf}{Congestive heart failure within 30 days prior to surgery}
#'  \item{hypermed}{Hyperetnsion requiring medication}
#'  \item{dialysis}{Currently requiring or on dialysis}
#'  \item{discancr}{Disseminated cancer}
#'  \item{steroid}{Steroid/immunosuppressant use for a chronic condition}
#'  \item{wtloss}{>10% weight loss of body weight within 6 months prior to surgery}
#'  \item{bleeddis}{Nleeding disorders}
#'  \item{wndclas}{Wound classification}
#'  \item{spill}{Presumptive bile spill, based on wound classification}
#'  \item{optime}{Total operation time in minutes}
#'  \item{supinfec}{Superficial incisional surgical site infection}
#'  \item{wndinfd}{Deep incisional surgical site infection}
#'  \item{orgspcssi}{Organ-space surgical site infection}
#'  \item{yrdeath}{Year of death}
#'  \item{mort}{Death within 30 days of surgery}
#'  \item{tothlos}{Length of total hospital stay in days}
#'  \item{dehis}{Wound disruption}
#'  \item{oupneumo}{Postoperative pneumonia}
#'  \item{reintub}{Unplanned intubation}
#'  \item{pulembol}{Pulmonary embolism}
#'  \item{failwean}{On ventilator >48 hours postoperatively}
#'  \item{renainsf}{Progressive renal insufficiency}
#'  \item{oprenafl}{Acute renal failure requiring dialysis}
#'  \item{urninfec}{Urinary tract infection}
#'  \item{cnscva}{CVA/stroke with neurological deficit}
#'  \item{cdarrest}{Intraoperative or postoperative cardiac arrest requiring CPR}
#'  \item{cdmi}{Intraoperative or postoperative myocardial infarction}
#'  \item{othbleed}{Intraoperative or postoperative (within 72 hours of surgery start) blood transfusions}
#'  \item{othdvt}{Vein thrombosis requiring therapy}
#'  \item{othsysep}{Sepsis}
#'  \item{othseshock}{Septic shock}
#'  \item{returnor}{Unplanned reoperation}
#'  \item{readmission1}{Any hospital readmission}
#'  \item{podiag}{Postoperative diagnosis (ICD9)}
#'  \item{podiag10}{Postoperative diagnosis(ICD10)}
#'  \item{dindo}{Clavien-Dindo classification}
#'  \item{dindo_min}{Minor complication (Dindo-Clavien 1 or 2)}
#'  \item{dindo_maj}{Major complication (Dindo-Clavien 3 or more)}
#'  \item{ioc}{Intraoperative cholangiogram performed}
#'}
#'
#' @source \url{https://www.facs.org/quality-programs/acs-nsqip}
"df"

#' Propensity score matched elective laparoscopic cholecystectomies from NSQIP Registry
#'
#' A dataset containing 48,240 records of elective laparoscopic cholecystectomies from the NSQIP registry.
#' This data was derived from a larger dataset, `nsqipBileSpill::df`, by propensity score matching for assignment
#' to the variable `spill` against various pre-operative risk factors.
#'
#' @format A data frame with 48,240 rows and 56 variables:
#' \describe{
#'  \item{sex}{Logical, TRUE for male, FALSE for female}
#'  \item{age}{Age in years}
#'  \item{bmi}{BMI of patient in kg/m^2}
#'  \item{diabetes}{Diabetes mellitus with oral agents or insulin}
#'  \item{insulin}{Insulin dependent diabetes mellitus}
#'  \item{smoke}{Current smoker within 1 year}
#'  \item{dyspnea}{Presence of dypsnea}
#'  \item{preopindependent}{Functionally independent prior to surgery}
#'  \item{hxcopd}{History of severe COPD}
#'  \item{ascites}{Ascites within 30 days prior to surgery}
#'  \item{hxchf}{Congestive heart failure within 30 days prior to surgery}
#'  \item{hypermed}{Hyperetnsion requiring medication}
#'  \item{dialysis}{Currently requiring or on dialysis}
#'  \item{discancr}{Disseminated cancer}
#'  \item{steroid}{Steroid/immunosuppressant use for a chronic condition}
#'  \item{wtloss}{>10% weight loss of body weight within 6 months prior to surgery}
#'  \item{bleeddis}{Nleeding disorders}
#'  \item{spill}{Presumptive bile spill, based on wound classification}
#'  \item{optime}{Total operation time in minutes}
#'  \item{supinfec}{Superficial incisional surgical site infection}
#'  \item{wndinfd}{Deep incisional surgical site infection}
#'  \item{orgspcssi}{Organ-space surgical site infection}
#'  \item{mort}{Death within 30 days of surgery}
#'  \item{tothlos}{Length of total hospital stay in days}
#'  \item{dindo_min}{Minor complication (Dindo-Clavien 1 or 2)}
#'  \item{dindo_maj}{Major complication (Dindo-Clavien 3 or more)}
#'  \item{ioc}{Intraoperative cholangiogram performed}
#'  \item{distance}{Estimated distance measure from propenstiy score match}
#'  \item{weights}{The weights assigned to each unit in the matching process. Unmatched units have weights equal to 0. Matched treated units have weight 1. Each matched control unit has weight proportional to the number of treatment units to which it was matched, and the sum of the control weights is equal to the number of uniquely matched control units}
#'}
#'
#' @source \url{https://www.facs.org/quality-programs/acs-nsqip}
"df_match"
