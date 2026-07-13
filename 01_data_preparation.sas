/****************************************************************************************/
/* 01_data_preparation.sas                                                              */
/* Data preparation for wdLPS analysis                                                  */
/* Clean version for GitHub/GitLab and AdClin                                           */
/****************************************************************************************/

/*=======================================================================================*/
/* 1. LIBNAMES                                                                           */
/*=======================================================================================*/

libname DIAG "..\DONNES FINALES\DIAG";
libname DM   "..\DONNES FINALES\DM";
libname INC  "..\DONNES FINALES\INC";
libname META "..\DONNES FINALES\META";
libname MOL  "..\DONNES FINALES\MOL";
libname REL  "..\DONNES FINALES\REL";
libname RELS "..\DONNES FINALES\RELS";
libname SMETA "..\DONNES FINALES\smeta";
libname SYST "..\DONNES FINALES\SYST";
libname TRT  "..\DONNES FINALES\TRT";

options fmtsearch=(DIAG.formats DM.formats INC.formats META.formats
                   MOL.formats REL.formats RELS.formats SMETA.formats
                   SYST.formats TRT.formats _Adclin);

/*=======================================================================================*/
/* 2. INCLUSION DATASET                                                                  */
/*=======================================================================================*/

data inclusion;
    set INC.inc;
run;

proc sort data=inclusion; by redcap_data_access_group; run;

data inclusion;
    set inclusion;
    if inclflag ne 1 then delete;
run;

/*=======================================================================================*/
/* 3. IMPORT MAIN TABLES AND SORT                                                        */
/*=======================================================================================*/

data DM;   set DM.DM;   run;
data Inc;  set Inc.Inc; run;
data DIAG; set DIAG.DIAG; run;
data TRT;  set TRT.TRT; run;
data MOL;  set MOL.MOL; run;

proc sort data=DM;   by record_id; run;
proc sort data=Inc;  by record_id; run;
proc sort data=DIAG; by record_id; run;
proc sort data=TRT;  by record_id; run;
proc sort data=MOL;  by record_id; run;

/*=======================================================================================*/
/* 4. MERGE INTO FUSION1                                                                 */
/*=======================================================================================*/

data fusion1;
    merge DM Inc DIAG TRT MOL;
    by record_id;
run;

/*=======================================================================================*/
/* 5. BASIC DERIVED VARIABLES                                                            */
/*=======================================================================================*/

data fusion1;
    set fusion1;

    /* Age at diagnosis */
    age_diag = round((dateoforiginaldiagnosis - birthdate) / 365.25);
    label age_diag = "Age at diagnosis";

    if 0 < age_diag < 65 then agecod = 1;
    if age_diag >= 65 then agecod = 2;

    /* Tumor size categories */
    if 0 < sizeoftumour < 50 then sizcod = 1;
    if 50 <= sizeoftumour <= 100 then sizcod = 2;
    if 100 < sizeoftumour then sizcod = 3;

    /* Year of diagnosis */
    Yeardiagnosis = year(dateoforiginaldiagnosis);
    label Yeardiagnosis = "Year of diagnosis";
run;

/*=======================================================================================*/
/* 6. DEPTH OF TUMOR                                                                     */
/*=======================================================================================*/

data fusion1;
    set fusion1;

    informat Depth_of_tumourcod $200.;
    format   Depth_of_tumourcod $200.;

    if depthoftumor = 1 then Depth_of_tumourcod = "Deep";
    if depthoftumor = 2 then Depth_of_tumourcod = "Superficial";
    if depthoftumor = 3 then Depth_of_tumourcod = "Deep";

    label Depth_of_tumourcod = "Depth of tumor";
run;

/*=======================================================================================*/
/* 7. SITE CATEGORIES                                                                     */
/*=======================================================================================*/

data fusion1;
    set fusion1;

    if siteoftumor in (2,3,4,5,6,7,8,9,10,11,12,13) then grandecat = 1;
    if siteoftumor in (14,15,16,17,18,19,20,21,22,23,24,25,26,27) then grandecat = 2;
    if siteoftumor in (35,36,37,38,39,41,40,42) then grandecat = 3;
    if siteoftumor in (29,30,31,32,33,34) then grandecat = 4;
    if siteoftumor in (43,44,45,46,47,48,49,50,51,52,60,62,64,60,65,78,80,81,82,
                       61,63,66,69,73,74,75,76,79,77) then grandecat = 5;
    if siteoftumor in (70,71,72,67,55,54,57,68) then grandecat = 6;
run;

proc format;
    value site
        1 = "Head and neck"
        2 = "Trunk"
        3 = "Upper limb"
        4 = "Lower limb"
        5 = "Visceral organs and endocrine glands"
        6 = "Genital and urinary regions";

    value agg
        1 = "<65 years"
        2 = ">= 65 years";

    value sizz
        1 = "<=5 cm"
        2 = "5-10 cm"
        3 = ">10 cm";
run;

data fusion1;
    set fusion1;

    format grandecat site.;
    label grandecat = "Site of tumor";

    format agecod agg.;
    label agecod = "Age at diagnosis";

    format sizcod sizz.;
    label sizcod = "Tumor size";
run;

/*=======================================================================================*/
/* 8. ANALYSIS POPULATION (analyse1)                                                     */
/*=======================================================================================*/

data analyse1;
    set fusion1;
    if inclflag = 1;
run;

/*=======================================================================================*/
/* 9. SYSTEMIC TREATMENT PREPARATION                                                     */
/*=======================================================================================*/

data syst;
    set SYST.syst;
run;

/* Remove empty repeat instances */
data syst_etape1;
    set syst;
    if redcap_repeat_instance = . then delete;
run;

proc sort data=syst_etape1; by record_id; run;
proc sort data=analyse1;   by record_id; run;

/* Merge with analysis population */
data syst_etape2;
    merge syst_etape1 analyse1(in=A);
    by record_id;
    if A;
run;

/*=======================================================================================*/
/* 10. TOTAL NUMBER OF PRIMARY TUMOR LINES                                               */
/=======================================================================================*/

data syst_primary;
    set syst_etape2;
    if systtrt = 1;
run;

proc sort data=syst_primary; by record_id systlinenb; run;

data nbrelignestotal;
    set syst_primary;
    by record_id systlinenb;
    if last.record_id then nbligne_primary = systlinenb;
    keep record_id nbligne_primary;
run;

/*=======================================================================================*/
/* 11. NEOADJUVANT, ADJUVANT, PALLIATIVE LINE COUNTS                                     */
/*=======================================================================================*/

/* Neoadjuvant */
data syst_neo;
    set syst_etape2;
    if systtrtset = 1;
run;

proc sql;
    create table nbrelignesneoadj as
    select record_id, count(*) as nbligne_neoadj
    from syst_neo
    group by record_id;
quit;

/* Adjuvant */
data syst_adj;
    set syst_etape2;
    if systtrtset = 2;
run;

proc sql;
    create table nbrelignesadj as
    select record_id, count(*) as nbligne_adj
    from syst_adj
    group by record_id;
quit;

/* Palliative */
data syst_pallia;
    set syst_etape2;
    if systtrtset = 3;
run;

proc sql;
    create table nbrelignespallia as
    select record_id, count(*) as nbligne_pallia
    from syst_pallia
    group by record_id;
quit;

/*=======================================================================================*/
/* 12. SYSTEMIC TREATMENT YES/NO                                                         */
/*=======================================================================================*/

data syst_yes;
    set syst_etape2;
    if systtrt = 1 then SYST = 1;
    keep record_id SYST;
run;

proc sort data=syst_yes nodupkey; by record_id; run;

/*=======================================================================================*/
/* 13. MERGE ALL LINE COUNTS INTO analyse1                                               */
/*=======================================================================================*/

proc sort data=analyse1;          by record_id; run;
proc sort data=nbrelignestotal;   by record_id; run;
proc sort data=nbrelignesneoadj;  by record_id; run;
proc sort data=nbrelignesadj;     by record_id; run;
proc sort data=nbrelignespallia;  by record_id; run;
proc sort data=syst_yes;          by record_id; run;

data analyse1;
    merge analyse1
          nbrelignestotal
          nbrelignesneoadj
          nbrelignesadj
          nbrelignespallia
          syst_yes;
    by record_id;

    if nbligne_primary = . then nbligne_primary = 0;
    if nbligne_neoadj  = . then nbligne_neoadj  = 0;
    if nbligne_adj     = . then nbligne_adj     = 0;
    if nbligne_pallia  = . then nbligne_pallia  = 0;
    if SYST            = . then SYST            = 0;

    /* Indicators */
    neo_adj = (nbligne_neoadj >= 1);
    adj     = (nbligne_adj    >= 1);
    pallia  = (nbligne_pallia >= 1);

    label nbligne_primary = "Total number of lines for primary tumor";
    label neo_adj         = "Neoadjuvant treatment";
    label adj             = "Adjuvant treatment";
    label pallia          = "Palliative treatment";
run;

/*=======================================================================================*/
/* 14. FINAL wdLPS DATASET                                                               */
/*=======================================================================================*/

data wdlps;
    set analyse1;
    if histotype2 = 1 and gradeoftumour = 1;
run;

/****************************************************************************************/
/* END OF FILE                                                                           */
/****************************************************************************************/
