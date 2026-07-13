/*********************************************************************/
/* 02_tables.sas                                                     */
/* Tables for wdLPS analysis                                         */
/* Clean version for GitHub/GitLab and AdClin                        */
/*********************************************************************/

/*********************************************************************/
/* TABLE 1 – PATIENT AND TUMOR CHARACTERISTICS                       */
/*********************************************************************/

%Title(Table 1A Patient and tumor characteristics)
%Table1(
    PopDataset=analyse1,
    PopId=record_id,
    ColAll=yes "Total",
    PctCol=Nonmiss,
    PrintMissing=Yes,
    PopFilter=(histotype2=1 and gradeoftumour=1),

    Blocks=
        age_diag type=univ /
        agecod type=freq /
        agecod2 type=freq /
        sex type=freq /
        diagbiopsy type=freq /
        sitegroupe type=freq /
        Depth_of_tumourcod type=freq /
        radiationarea type=freq /
        grade_grouped type=freq format=grade_group. /
        sizeoftumour Tumor size mm type=univ /
        sizcod2 type=freq /
        m type=freq /
        statusatreferral type=freq /
        tttbeforereferral type=freq /
        ecog type=freq /
);

%Title(Table 1B MDM2 testing)
%Table1(
    PopDataset=analyse1,
    PopId=record_id,
    ColAll=yes "Total",
    PctSortCol=all,
    PctCol=Nonmiss,
    PrintMissing=Yes,
    PopFilter=(histotype2=1 and gradeoftumour=1),

    Blocks=
        molmdm2test type=freq /
        If yes /
        testMDM2@(molmdm2test=1) type=freq /
        molmdm2res@(molmdm2test=1) type=freq /
);

/*********************************************************************/
/* TABLE 2 – PRIMARY TUMOR TREATMENT                                 */
/*********************************************************************/

%Title(Table 2A Local treatment of primary tumor)
%Table1(
    PopDataset=analyse1,
    PopId=record_id,
    ColAll=yes "Total",
    PctCol=Nonmiss,
    PrintMissing=Yes,
    PopFilter=(histotype2=1 and m=0 and gradeoftumour=1),

    Blocks=
        surgeryoftumour type=freq /
        radiotherapyoftmour type=freq /
        trtothertumouttrt type=freq /
);

%Title(Table 2B Systemic treatment of primary tumor)
%Table1(
    PopDataset=analyse1,
    PopId=record_id,
    ColAll=yes "Total",
    PctCol=Nonmiss,
    PrintMissing=Yes,
    PopFilter=(histotype2=1 and m=0 and gradeoftumour=1),

    Blocks=
        syst type=freq /
        nbligne_primary type=freq /
        neo_adj type=freq /
        nbligne_neoadj type=freq /
        adj type=freq /
        nbligne_adj type=freq /
        pallia type=freq /
        nbligne_pallia type=freq /
);

/*********************************************************************/
/* TABLE 3 – METASTATIC DISEASE                                      */
/*********************************************************************/

%Title(Table 3A Diagnosis of metastatic disease)
%Table1(
    PopDataset=metaouinon,
    PopId=record_id,
    ColAll=yes "Total",
    PctCol=Nonmiss,
    PrintMissing=Yes,
    PopFilter=(histotype2=1 and gradeoftumour=1),

    Blocks=
        meta Metastatic disease including early metastasis type=freq /
        m type=freq /
        meta@(surgeryoftumour=1) Metastatic disease among patients who underwent surgery type=freq /
        nbrechutemetacod type=freq /
);

%Title(Table 3B Local treatment of metastatic disease)
%Table1(
    PopDataset=ttlocalmeta,
    PopId=record_id,
    ColAll=yes "Total",
    colvar=m,
    PctCol=Nonmiss,
    PrintMissing=Yes,
    PopFilter=(meta=1 and histotype2=1 and gradeoftumour=1),

    Blocks=
        metasurgery type=freq /
        metaother type=freq /
        Details of other local treatments type=freq /
        Radiotherapy@(metaother=1) type=freq /
        Radiofrequency@(metaother=1) type=freq /
        Cryotherapy@(metaother=1) type=freq /
        Other@(metaother=1) type=freq /
);

%Title(Table 3C Systemic treatment for metastatic disease)
%Table1(
    PopDataset=chimiometa2,
    PopId=record_id,
    ColAll=yes "Total",
    colvar=m,
    PctCol=Nonmiss,
    PrintMissing=Yes,
    PopFilter=(meta=1 and histotype2=1 and gradeoftumour=1),

    Blocks=
        syst_META type=freq /
        Among patients with systemic treatment type=freq /
        nbligne_meta@(syst_META=1) type=freq /
);

%Title(Table 3D Best response to first line systemic therapy)
%Table1(
    PopDataset=PFS1_all,
    PopId=record_id,
    ColAll=yes "Total",
    PctCol=Nonmiss,
    PrintMissing=Yes,
    PctSortCol=all,
    PopFilter=(histotype2=1 and gradeoftumour=1),

    Blocks=
        bestresponseligne1 type=freq /
);

%Title(Table 3E Best response to second line systemic therapy)
%Table1(
    PopDataset=PFS2_all,
    PopId=record_id,
    ColAll=yes "Total",
    PctCol=Nonmiss,
    PrintMissing=Yes,
    PctSortCol=all,
    PopFilter=(histotype2=1 and gradeoftumour=1),

    Blocks=
        bestresponseligne2 type=freq /
);

/*********************************************************************/
/* TABLE 4 – MULTIVARIATE COX ANALYSIS                               */
/*********************************************************************/

%Title(Table 4 Multivariate Cox regression analysis for overall survival)

proc phreg data=wdlps;
    class 
        agecod (ref=">= 65 years")
        sex (ref="Female")
        PScod (ref=LAST)
        sizcod
        sitegroupe
        surgeryoftumour (ref="No")
        m (ref="No");
    model delai_DCD*dcd(0) =
        agecod sex sizcod PScod sitegroupe surgeryoftumour m
        / rl ties=efron;
run;

/*********************************************************************/
/* SUPPLEMENTARY TABLES                                              */
/*********************************************************************/

%Title(Supplementary Table 1A Primary tumor treatment without surgery)
%Table1(
    PopDataset=analyse1,
    PopId=record_id,
    ColAll=yes "Total",
    colvar=histotype,
    PctCol=Nonmiss,
    PrintMissing=Yes,
    PopFilter=(surgeryoftumour=0 and histotype2=1 and m=0 and gradeoftumour=1),

    Blocks=
        radiotherapyoftmour type=freq /
        syst Systemic treatment of primary tumor type=freq /
);

%Title(Supplementary Table 1B Best response to first line systemic therapy RECIST 1 1)
%Table1(
    PopDataset=BRL1,
    PopId=record_id,
    ColAll=yes "Total",
    PctCol=Nonmiss,
    PrintMissing=Yes,
    PctSortCol=all,
    PopFilter=(histotype2=1 and m=0 and gradeoftumour=1),

    Blocks=
        systresponse type=freq /
);

%Title(Supplementary Table 1C Best response to second line systemic therapy RECIST 1 1)
%Table1(
    PopDataset=BRL2,
    PopId=record_id,
    ColAll=yes "Total",
    PctCol=Nonmiss,
    PrintMissing=Yes,
    PctSortCol=all,
    PopFilter=(histotype2=1 and m=0 and gradeoftumour=1),

    Blocks=
        systresponse type=freq /
);

%Title(Supplementary Table 2A Local relapse of primary tumor)
%Table1(
    PopDataset=rechutelocaleouinon,
    PopId=record_id,
    ColAll=yes "Total",
    PctCol=Nonmiss,
    PrintMissing=Yes,
    PctSortCol=all,
    PopFilter=(histotype2=1 and m=0 and gradeoftumour=1),

    Blocks=
        rechute_locale type=freq /
        Among patients with local relapse type=freq /
        surgery@(rechute_locale=1) type=freq /
        radiotherapy@(rechute_locale=1) type=freq /
);

%Title(Supplementary Table 2B Systemic treatment for local relapse)
%Table1(
    PopDataset=rechutelocaleouinon,
    PopId=record_id,
    ColAll=yes "Total",
    PctCol=Nonmiss,
    PrintMissing=Yes,
    PctSortCol=all,
    PopFilter=(rechute_locale=1 and histotype2=1 and m=0 and gradeoftumour=1),

    Blocks=
        syst_LR type=freq /
        nblineforlr type=freq /
        adjforLR type=freq /
        nbligne_adjforLR type=freq /
        neoadjforLR type=freq /
        nbligne_neoadjforLR type=freq /
        palliaforLR type=freq /
        nblignespalliaforLR type=freq /
);

%Title(Supplementary Table 3A First line systemic treatment for metastatic disease)
%Table1(
    PopDataset=drug_formetaPFS1,
    PopId=record_id,
    ColAll=yes "Total",
    PctCol=Nonmiss,
    PrintMissing=Yes,
    PctSortCol=all,
    PopFilter=(histotype2=1 and gradeoftumour=1),

    Blocks=
        familydrug type=freq /
        Immune checkpoint inhibitors /
        smeta_char@(familydrug=1) type=freq /
        MDM2 inhibitors /
        smeta_char@(familydrug=2) type=freq /
        PARP inhibitors /
        smeta_char@(familydrug=3) type=freq /
        CDK4 6 inhibitors /
        smeta_char@(familydrug=4) type=freq /
        Conventional cytotoxic /
        smeta_char@(familydrug=5) type=freq /
        Others /
        smeta_char@(familydrug=6) type=freq /
);

%Title(Supplementary Table 3B Second line systemic treatment for metastatic disease)
%Table1(
    PopDataset=drug_formetaPFS2,
    PopId=record_id,
    ColAll=yes "Total",
    PctCol=Nonmiss,
    PrintMissing=Yes,
    PctSortCol=all,
    PopFilter=(histotype2=1 and gradeoftumour=1),

    Blocks=
        familydrug type=freq /
        Immune checkpoint inhibitors /
        smeta_char@(familydrug=1) type=freq /
        MDM2 inhibitors /
        smeta_char@(familydrug=2) type=freq /
        PARP inhibitors /
        smeta_char@(familydrug=3) type=freq /
        CDK4 6 inhibitors /
        smeta_char@(familydrug=4) type=freq /
        Conventional cytotoxic /
        smeta_char@(familydrug=5) type=freq /
        Others /
        smeta_char@(familydrug=6) type=freq /
);

%Title(Supplementary Table 3C Third line systemic treatment for metastatic disease)
%Table1(
    PopDataset=drug_formetaPFS3,
    PopId=record_id,
    ColAll=yes "Total",
    PctCol=Nonmiss,
    PrintMissing=Yes,
    PctSortCol=all,
    PopFilter=(histotype2=1 and gradeoftumour=1),

    Blocks=
        familydrug type=freq /
        Immune checkpoint inhibitors /
        smeta_char@(familydrug=1) type=freq /
        MDM2 inhibitors /
        smeta_char@(familydrug=2) type=freq /
        PARP inhibitors /
        smeta_char@(familydrug=3) type=freq /
        CDK4 6 inhibitors /
        smeta_char@(familydrug=4) type=freq /
        Conventional cytotoxic /
        smeta_char@(familydrug=5) type=freq /
        Others /
        smeta_char@(familydrug=6) type=freq /
);

%Title(Supplementary Table 3D Fourth line systemic treatment for metastatic disease)
%Table1(
    PopDataset=drug_formetaPFS4,
    PopId=record_id,
    ColAll=yes "Total",
    PctCol=Nonmiss,
    PrintMissing=Yes,
    PctSortCol=all,
    PopFilter=(histotype2=1 and gradeoftumour=1),

    Blocks=
        familydrug type=freq /
        Immune checkpoint inhibitors /
        smeta_char@(familydrug=1) type=freq /
        MDM2 inhibitors /
        smeta_char@(familydrug=2) type=freq /
        PARP inhibitors /
        smeta_char@(familydrug=3) type=freq /
        CDK4 6 inhibitors /
        smeta_char@(familydrug=4) type=freq /
        Conventional cytotoxic /
        smeta_char@(familydrug=5) type=freq /
        Others /
        smeta_char@(familydrug=6) type=freq /
);

%Title(Supplementary Table 3E Fifth line systemic treatment for metastatic disease)
%Table1(
    PopDataset=drug_formetaPFS5,
    PopId=record_id,
    ColAll=yes "Total",
    PctCol=Nonmiss,
    PrintMissing=Yes,
    PctSortCol=all,
    PopFilter=(histotype2=1 and gradeoftumour=1),

    Blocks=
        familydrug type=freq /
        Immune checkpoint inhibitors /
        smeta_char@(familydrug=1) type=freq /
        MDM2 inhibitors /
        smeta_char@(familydrug=2) type=freq /
        PARP inhibitors /
        smeta_char@(familydrug=3) type=freq /
        CDK4 6 inhibitors /
        smeta_char@(familydrug=4) type=freq /
        Conventional cytotoxic /
        smeta_char@(familydrug=5) type=freq /
        Others /
        smeta_char@(familydrug=6) type=freq /
);

/*********************************************************************/
/* END OF FILE                                                       */
/*********************************************************************/
