/*********************************************************************/
/* 03_survival_figures.sas                                           */
/* Figures for wdLPS analysis                                        */
/* Clean version for GitHub/GitLab                                   */
/*********************************************************************/

ods graphics / reset=all;
ods listing style=htmlblue;
ods escapechar='^';

/* Harmonized style */
proc template;
    define style Styles.ArielStyle;
        parent=Styles.HTMLBlue;
        style GraphFonts /
            'GraphDataFont' = ("Arial",8pt)
            'GraphValueFont' = ("Arial",8pt)
            'GraphLabelFont' = ("Arial",9pt)
            'GraphTitleFont' = ("Arial",10pt);
    end;
run;

ods listing style=Styles.ArielStyle;

/*********************************************************************/
/* RESET ODS                                                         */
/*********************************************************************/
%macro reset_ods;
    ods _all_ close;
    ods listing close;
    ods html close;
    ods results off;
    ods noresults;
    ods graphics off;

    title;
    footnote;

    ods escapechar='^';
    ods path reset;
    ods path sashelp.tmplmst(read);
    options nodate nonumber;
%mend;

/*********************************************************************/
/* FIGURE 1A — Overall survival (OS)                                 */
/*********************************************************************/
%reset_ods;

title "Figure 1A. Overall survival (OS)";

ods graphics / reset=all imagefmt=pdf antialiasmax=1400;
ods layout gridded columns=1;
ods region;

%newsurv(
    DATA=wdlps,
    TIME=delai_DCD,
    CENS=dcd,
    CEN_VL=0,
    TIMELIST=12 24 60,
    COLOR=blue,
    SUMMARY=1,
    YLABEL=Overall survival (OS),
    XLABEL=Months from diagnosis,
    rISKLIST=0 to 160 by 20,
    risklabellocation=left,
    RISKLOCATION=BOTTOM,
    parheader=Number at risk,
    paralign=labels,
    RISKCOLOR=1,
    CONFTYPE=LOGLOG,
    PLOTCI=0,
    border=0,
    SHOWWALLS=0,
    PLOTCIFILLTRANSPARENCY=0.90,
    DISPLAY=LEGEND
);

ods region;
ods layout end;

/*********************************************************************/
/* FIGURE 1B — Overall survival stratified by age                    */
/*********************************************************************/
%reset_ods;

title "Figure 1B. Overall survival stratified by age";

ods graphics / reset=all imagefmt=pdf antialiasmax=1400;
ods layout gridded columns=1;
ods region;

%newsurv(
    DATA=wdlps,
    TIME=delai_DCD,
    CENS=dcd,
    CEN_VL=0,
    TIMELIST=12 24 60,
    COLOR=blue green,
    SUMMARY=1,
    YLABEL=Overall survival (OS),
    XLABEL=Months from diagnosis,
    CLASS=agecod,
    rISKLIST=0 to 160 by 20,
    risklabellocation=left,
    RISKLOCATION=BOTTOM,
    parheader=Number at risk,
    paralign=labels,
    RISKCOLOR=1,
    CONFTYPE=LOGLOG,
    PLOTCI=0,
    border=0,
    SHOWWALLS=0,
    PLOTCIFILLTRANSPARENCY=0.90,
    DISPLAY=LEGEND
);

ods region;
ods layout end;

/*********************************************************************/
/* FIGURE 1C — Overall survival stratified by surgery                */
/*********************************************************************/
%reset_ods;

title "Figure 1C. Overall survival stratified by surgery of primary tumor";

ods graphics / reset=all imagefmt=pdf antialiasmax=1400;
ods layout gridded columns=1;
ods region;

%newsurv(
    DATA=wdlps,
    TIME=delai_DCD,
    CENS=dcd,
    CEN_VL=0,
    TIMELIST=12 24 60,
    COLOR=blue green,
    SUMMARY=1,
    YLABEL=Overall survival (OS),
    XLABEL=Months from diagnosis,
    CLASS=surgeryoftumour,
    rISKLIST=0 to 160 by 20,
    risklabellocation=left,
    RISKLOCATION=BOTTOM,
    parheader=Number at risk,
    paralign=labels,
    RISKCOLOR=1,
    CONFTYPE=LOGLOG,
    PLOTCI=0,
    border=0,
    SHOWWALLS=0,
    PLOTCIFILLTRANSPARENCY=0.90,
    DISPLAY=LEGEND
);

ods region;
ods layout end;

/*********************************************************************/
/* FIGURE 1D — Overall survival stratified by synchronous metastasis */
/*********************************************************************/
%reset_ods;

title "Figure 1D. Overall survival stratified by synchronous metastasis";

data wdlps;
    set wdlps;
    label m = "Synchronous metastasis";
run;

ods graphics / reset=all imagefmt=pdf antialiasmax=1400;
ods layout gridded columns=1;
ods region;

%newsurv(
    DATA=wdlps,
    TIME=delai_DCD,
    CENS=dcd,
    CEN_VL=0,
    TIMELIST=12 24 60,
    COLOR=blue purple,
    SUMMARY=1,
    YLABEL=Overall survival (OS),
    XLABEL=Months from diagnosis,
    CLASS=m,
    rISKLIST=0 to 160 by 20,
    risklabellocation=left,
    RISKLOCATION=BOTTOM,
    parheader=Number at risk,
    paralign=labels,
    RISKCOLOR=1,
    CONFTYPE=LOGLOG,
    PLOTCI=0,
    border=0,
    SHOWWALLS=0,
    PLOTCIFILLTRANSPARENCY=0.90,
    DISPLAY=LEGEND
);

ods region;
ods layout end;

/*********************************************************************/
/* FIGURE 2A — PFS1                                                   */
/*********************************************************************/
%reset_ods;

title "Figure 2A. Progression-free survival of metastatic line 1 (PFS1)";

ods graphics / reset=all imagefmt=pdf antialiasmax=1400;
ods layout gridded columns=1;
ods region;

%newsurv(
    DATA=wdlpsPFS1,
    TIME=delaiPFSL1,
    CENS=PFSL1,
    CEN_VL=0,
    TIMELIST=6 12,
    COLOR=blue,
    SUMMARY=1,
    YLABEL=Progression-free survival L1 (PFS1),
    XLABEL=Time since beginning of systemic L1 (months),
    rISKLIST=0 to 160 by 20,
    risklabellocation=left,
    RISKLOCATION=BOTTOM,
    parheader=Number at risk,
    paralign=labels,
    RISKCOLOR=1,
    CONFTYPE=LOGLOG,
    PLOTCI=0,
    border=0,
    SHOWWALLS=0,
    PLOTCIFILLTRANSPARENCY=0.90,
    DISPLAY=LEGEND
);

ods region;
ods layout end;

/*********************************************************************/
/* FIGURE 2B — Swimmer plot L1                                       */
/*********************************************************************/
%reset_ods;

title "Figure 2B. Swimmer plot of systemic treatments for metastatic line 1";

proc sgplot data=wdlpsPFS1_swimmer noborder;

    hbarparm category=record_id response=delaiBrigimadlin1 /
        barwidth=0.9 fillattrs=(color=CXFFB6C1 transparency=0.3)
        outlineattrs=(color=CXFFB6C1 thickness=0.9)
        name='a' legendlabel='Brigimadlin';

    hbarparm category=record_id response=delaiCarebo1 /
        barwidth=0.7 fillattrs=(color=CXFFA500 transparency=0.5)
        outlineattrs=(color=CXFFA500 thickness=0)
        name='b' legendlabel='Carboplatin';

    hbarparm category=record_id response=delaiEtoposide1 /
        barwidth=0.05 fillattrs=(color=CXDC143C transparency=0.0)
        outlineattrs=(color=CXDC143C thickness=0.05)
        name='h' legendlabel='Etoposide';

    hbarparm category=record_id response=delaidoxo1 /
        barwidth=0.9 fillattrs=(color=CX4DBFBC transparency=0.3)
        outlineattrs=(color=CX4DBFBC thickness=0.9)
        name='d' legendlabel='Doxorubicin';

    hbarparm category=record_id response=delaiIfosfamide1 /
        barwidth=0.05 fillattrs=(color=CX9370DB transparency=0.0)
        outlineattrs=(color=CX9370DB thickness=0)
        name='i' legendlabel='Ifosfamide';

    hbarparm category=record_id response=delaiDacarb1 /
        barwidth=0.07 fillattrs=(color=CX000080 transparency=0.0)
        outlineattrs=(color=CX000080 thickness=0)
        name='g' legendlabel='Dacarbazine';

    hbarparm category=record_id response=delaiGemci1 /
        barwidth=0.9 fillattrs=(color=CXFFD700 transparency=0.8)
        outlineattrs=(color=CXFFD700 thickness=0.9)
        name='e' legendlabel='Gemcitabine';

    hbarparm category=record_id response=delaicyclo1 /
        barwidth=0.9 fillattrs=(color=CX6EA645 transparency=0.4)
        outlineattrs=(color=CX6EA645 thickness=0)
        name='c' legendlabel='Cyclophosphamide';

    hbarparm category=record_id response=delaiRO50453371 /
        barwidth=0.9 fillattrs=(color=CX8B4513 transparency=0.3)
        outlineattrs=(color=CX8B4513 thickness=0)
        name='f' legendlabel='RO5045337 / RG7112 (Nutlin)';

    scatter X=delai_prog1 Y=record_id /
        markerattrs=(symbol=CIRCLEFILLED size=9 color=red)
        name='j' legendlabel='Progression';

    scatter X=delaidc1 Y=record_id /
        markerattrs=(symbol=PLUS size=20 color=red)
        name='k' legendlabel='Death';

    scatter X=delaitox1 Y=record_id /
        markerattrs=(symbol=star size=9 color=blue)
        name='l' legendlabel='Toxicity';

    yaxis display=(noticks novalues noline)
          label='Patients ranked by descending PFS-L1'
          min=0 FITPOLICY=none
          VALUEATTRS=(Family=Arial Size=8);

    keylegend 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' /
        noborder location=outside;

    xaxis label="Time since systemic L1 (months)";
run;

/*********************************************************************/
/* FIGURE 2C — PFS2                                                   */
/*********************************************************************/
%reset_ods;

title "Figure 2C. Progression-free survival of metastatic line 2 (PFS2)";

ods graphics / reset=all imagefmt=pdf antialiasmax=1400;
ods layout gridded columns=1;
ods region;

%newsurv(
    DATA=wdlpsPFS2,
    TIME=delaiPFSL2,
    CENS=PFSL2,
    CEN_VL=0,
    TIMELIST=6 12,
    COLOR=blue,
    SUMMARY=1,
    YLABEL=Progression-free survival L2 (PFS2),
    XLABEL=Time since beginning of systemic L2 (months),
    rISKLIST=0 to 160 by 20,
    risklabellocation=left,
    RISKLOCATION=BOTTOM,
    parheader=Number at risk,
    paralign=labels,
    RISKCOLOR=1,
    CONFTYPE=LOGLOG,
    PLOTCI=0,
    border=0,
    SHOWWALLS=0,
    PLOTCIFILLTRANSPARENCY=0.90,
    DISPLAY=LEGEND
);

ods region;
ods layout end;

/*********************************************************************/
/* FIGURE 2D — Swimmer plot L2                                       */
/*********************************************************************/
%reset_ods;

title "Figure 2D. Swimmer plot of systemic treatments for metastatic line 2";

proc sgplot data=wdlpsPFS2_swimmer noborder;

    hbarparm category=record_id response=delaiAbema /
        barwidth=0.9 fillattrs=(color=CX2F4F4F transparency=0.4)
        outlineattrs=(color=CX2F4F4F thickness=0)
        name='a' legendlabel='Abemaciclib';

    hbarparm category=record_id response=delaiDacarb /
        barwidth=0.07 fillattrs=(color=CX000080 transparency=0.0)
        outlineattrs=(color=CX000080 thickness=0)
        name='b' legendlabel='Dacarbazine';

    hbarparm category=record_id response=delaiDoxo /
        barwidth=0.9 fillattrs=(color=CX4DBFBC transparency=0.3)
        outlineattrs=(color=CX4DBFBC thickness=0.9)
        name='c' legendlabel='Doxorubicin';

    hbarparm category=record_id response=delaiErib /
        barwidth=0.9 fillattrs=(color=CX6EA645 transparency=0.4)
        outlineattrs=(color=CX6EA645 thickness=0)
        name='d' legendlabel='Eribulin';

    hbarparm category=record_id response=delaiGemcita /
        barwidth=0.9 fillattrs=(color=CXFFD700 transparency=0.8)
        outlineattrs=(color=CXFFD700 thickness=0.9)
        name='e' legendlabel='Gemcitabine';

    hbarparm category=record_id response=delaiLiposomal /
        barwidth=0.9 fillattrs=(color=CXD3D3D3 transparency=0.4)
        outlineattrs=(color=CXD3D3D3 thickness=0)
        name='f' legendlabel='Liposomal doxorubicin';

    hbarparm category=record_id response=delaiOther /
        barwidth=0.9 fillattrs=(color=CX000000 transparency=0.4)
        outlineattrs=(color=CX000000 thickness=0)
        name='g' legendlabel='Other';

    hbarparm category=record_id response=delaiTrabec /
        barwidth=0.9 fillattrs=(color=CXFF69B4 transparency=0.4)
        outlineattrs=(color=CXFF69B4 thickness=0)
        name='h' legendlabel='Trabectedin';

    scatter X=delai_prog2 Y=record_id /
        markerattrs=(symbol=CIRCLEFILLED size=9 color=red)
        name='i' legendlabel='Progression';

    scatter X=delaidc2 Y=record_id /
        markerattrs=(symbol=PLUS size=20 color=red)
        name='j' legendlabel='Death';

    scatter X=delaitox2 Y=record_id /
        markerattrs=(symbol=star size=9 color=blue)
        name='k' legendlabel='Toxicity';

    yaxis display=(noticks novalues noline)
          label='Patients ranked by descending PFS-L2'
          min=0 FITPOLICY=none
          VALUEATTRS=(Family=Arial Size=8);

    keylegend 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' /
        noborder location=outside;

    xaxis label="Time since systemic L2 (months)";
run;

/*********************************************************************/
/* END OF FILE                                                       */
/*********************************************************************/
