    %let pgm=utl-identify-overlapping-drug-exposures-of-at-least-one-day-using-r-iranges-package;

    %stop_submission;

    Identify overlapping drug exposures of at least one day using r iranges package


           TWO SOLUTIONS
              1 r IRanges package
              2 sas
                Keintz, Mark
                mkeintz@outlook.com

                Bartosz Jablonski
                yabwon@gmail.com


    SOAPBOX ON
    Significant portion of package IRanges its implementation in C for performance-critical operations.
    I expect a sas hash to also be fast.
    Not hard to add the length of the overlaps?
    SOAPBOX OFF


    github
    https://tinyurl.com/2xzu5ddj
    https://github.com/rogerjdeangelis/utl-identify-overlapping-drug-exposures-of-at-least-one-day-using-r-iranges-package

    communities.sas
    https://tinyurl.com/57n2m7ky
    https://communities.sas.com/t5/SAS-Enterprise-Guide/Dealing-with-overlaps-dates-for-drug-exposures/m-p/754485#M39127


    PROBLEM
                                      DAYS
    ID-RX     2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20    ID-RX
           ---+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+---
     1=zin +  ---------------x-----x------------ zin                   + 1=zin
           |                 |     |                                   |
           |                 |     |            ID DRUG1 DRUG2         |
     1=fla +                 |     x------ fla   1 zin   cip           + 1=fla
           |                 |     |             1 zin   amo           |
           |                 |     |             1 zin   fla           |
     1=cip +       cip ------x---  |             1 cip   amo           + 1=cip
           |                 |     |             1 amo   fla           |
           |                 |     |                                   |
     1=amo +             amo x-----x-----------------------x---------  + 1=amo
           |                                               |           |
           |                                               |           |
     1=aax +                                               x------ aax + 1=aax
           ---+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+---
              2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20
                                       DAYS


    RELATED REPOS
    ----------------------------------------------------------------------------------------------------------------------------------
    https://github.com/rogerjdeangelis/utl-Identifying-Gaps-and-Overlaps-insurance-coverage-among-multiple-plan-types-episode-analysis
    https://github.com/rogerjdeangelis/utl-identify-overlapping-intervals-with-multiple-drug-exposure
    https://github.com/rogerjdeangelis/utl-identifying-overlapping-ranges-and-combining-into-one-range-sas-python-r
    https://github.com/rogerjdeangelis/utl-select-max-value-between-multiple-overlapping-start-and-end-dates-sas-dosubl
    https://github.com/rogerjdeangelis/utl-simple-ascii-plot-to-visually-display-the-the-overlap-of-two-time-series-proc-plot-graph
    https://github.com/rogerjdeangelis/utl-using-sas-multi-level-formats-to-count-ages-in-overlapping-categories
    https://github.com/rogerjdeangelis/utl_count_distinct_ids_in_rolling_overlapping_date_ranges
    https://github.com/rogerjdeangelis/utlfind-flag-overlapping-dates-between-two-tables


    /***********************************************************************************************************************************/
    /* INPUT                            | PROCESS                                   | OUTPUT                                           */
    /* =====                            | =======                                   | ======                                           */
    /* SD1.HAVE                         | %utl_rbeginx;                             | R                                                */
    /*                                  | parmcards4;                               |  ID  DRUG1  DRUG2                                */
    /* ID START END DRUG                | library(data.table);                      |                                                  */
    /*                                  | library(IRanges);                         |   1 1(zin) 2(cip)                                */
    /* 1   02   13   zin                | library(haven);                           |   1 1(zin) 3(amo)                                */
    /* 1   05   08   cip                | library(sqldf);                           |   1 1(zin) 4(fla)                                */
    /* 1   07   17   amo                | library(dplyr);                           |   1 2(cip) 3(amo)                                */
    /* 1   09   11   fla                | source("c:/oto/fn_tosas9x.R")             |   1 3(amo) 4(fla)                                */
    /* 1   14   16   aax                | options(sqldf.dll = "d:/dll/sqlean.dll")  |   1 3(amo) 5(aax)                                */
    /* 2   02   04   zin                | have<-as.data.table(                      |   2 3(amo) 4(fla)                                */
    /* 2   05   08   cip                |  read_sas("d:/sd1/have.sas7bdat"));       |                                                  */
    /* 2   09   13   amo                | have                                      |  SAS                                             */
    /* 2   11   12   fla                |                                           |   ID DRUG1  DRUG2                                */
    /* 2   15   18   aax                | want <- have[, {                          |                                                  */
    /*                                  |  rng <- IRanges(START, END)               |    1 1(zin) 2(cip)                               */
    /* libname sd1 "d:/sd1";            |  hits <- findOverlaps(rng)                |    1 1(zin) 3(amo)                               */
    /* data sd1.have;                   |  hits <- hits[queryHits(hits)             |    1 1(zin) 4(fla)                               */
    /* input id start                   |       < subjectHits(hits)]                |    1 2(cip) 3(amo)                               */
    /*   end drug$;                     |  if (length(hits)) {                      |    1 3(amo) 4(fla)                               */
    /* cards4;                          |    drugs <- .SD$DRUG                      |    1 3(amo) 5(aax)                               */
    /* 1  2 13 zin                      |    qh <- queryHits(hits)                  |    2 3(amo) 4(fla)                               */
    /* 1  5 8  cip                      |    sh <- subjectHits(hits)                |                                                  */
    /* 1  7 17 amo                      |    data.table(                            |                                                  */
    /* 1  9 11 fla                      |      DRUG1 = paste0(qh,"(",drugs[qh],")"),|                                                  */
    /* 1 14 16 aax                      |      DRUG2 = paste0(sh,"(",drugs[sh],")") |                                                  */
    /* 2  2  4 zin                      |    )                                      |                                                  */
    /* 2  5 8  cip                      |  }                                        |                                                  */
    /* 2  9 13 amo                      | }, by = ID]                               |                                                  */
    /* 2 11 12 fla                      | want                                      |                                                  */
    /* 2 15 18 aax                      | fn_tosas9x(                               |                                                  */
    /* ;;;;                             |       inp    = want                       |                                                  */
    /* run;quit;                        |      ,outlib ="d:/sd1/"                   |                                                  */
    /*                                  |      ,outdsn ="want"                      |                                                  */
    /*                                  |      )                                    |                                                  */
    /*                                  | ;;;;                                      |                                                  */
    /*                                  | %utl_rendx;                               |                                                  */
    /*                                  |                                           |                                                  */
    /*                                  | proc print data=sd1.want;                 |                                                  */
    /*                                  | run;quit;                                 |                                                  */
    /*                                  |                                           |                                                  */
    /*---------------------------------------------------------------------------------------------------------------------------------*/
    /*                                  | 2 SAS                                     |                                                  */
    /*                                  | =====                                     |                                                  */
    /*                                  |                                           |                                                  */
    /*        S                         | data temp (keep=patient date);            | P                                                */
    /*        T                         |   set have;                               | A                                                */
    /*        A           E             |   date=start_date;   output;              | T     S         E                                */
    /* P      R           N             |   date=end_date+1;   output;              | I     T         N               D                */
    /* A      T           D             |   format date date9.;                     | E     _         _               R                */
    /* T      _           _             | run;                                      | N     D         D               U                */
    /* I      D           D        D    |                                           | T     T         T               G                */
    /* E      A           A        R    | proc sort data=temp nodupkey;             |                                                  */
    /* N      T           T        U    | by patient date;                          | 1 19MAR1998 26JUL1998 amox,cipro,flagyl,zinc     */
    /* T      E           E        G    | run;                                      | 1 27JUL1998 18NOV1998 cef,cipro,flagyl,zinc      */
    /*                                  |                                           | 1 19NOV1998 01JUN2005 cef,flagyl,zinc            */
    /* 1 19-MAR-1998 26-JUL-1998 amox   | data temp2(rename=(date=st_dt             | 1 02JUN2005 24AUG2005 cef,flagyl                 */
    /* 1 19-MAR-1998 18-NOV-1998 cipro  |   d=en_dt));                              | 1 25AUG2005 15FEB2009 flagyl                     */
    /* 1 19-MAR-1998 01-JUN-2005 zinc   |   merge temp temp(rename                  | 2 19NOV1998 09JUL2003 amox                       */
    /* 1 19-MAR-1998 15-FEB-2009 flagyl |      = (patient=p date=d)                 | 2 10JUL2003 01JUN2005 cipro                      */
    /* 1 27-JUL-1998 24-AUG-2005 cef    |      firstobs=2);                         | 2 02JUN2005 31JUL2006 cipro,zinc                 */
    /* 2 19-NOV-1998 09-JUL-2003 amox   |   if patient=p;                           | 2 01AUG2006 15FEB2009 flagyl,zinc                */
    /* 2 10-JUL-2003 31-JUL-2006 cipro  |   drop p;                                 | 2 16FEB2009 16JUL2018 flagyl                     */
    /* 2 02-JUN-2005 15-FEB-2009 zinc   |   d=d-1;                                  | 3 16FEB2009 16JUL2018 cef,sec                    */
    /* 2 01-AUG-2006 16-JUL-2018 flagyl | run;                                      | 3 17JUL2018 25AUG2019 sec                        */
    /* 3 16-FEB-2009 16-JUL-2018 cef    |                                           | 4 16FEB2009 16FEB2009 xxx,yyy,zzz                */
    /* 3 16-FEB-2009 25-AUG-2019 sec    | proc sql;                                 | 4 17FEB2009 17FEB2009 zzz                        */
    /* 4 16-FEB-2009 16-FEB-2009 xxx    |   create table want as                    |                                                  */
    /* 4 16-FEB-2009 16-FEB-2009 yyy    |   select                                  |                                                  */
    /* 4 16-FEB-2009 17-FEB-2009 zzz    |     a.patient                             |                                                  */
    /*                                  |    ,a.st_dt                               |                                                  */
    /* data have;                       |    ,a.en_dt                               |                                                  */
    /* input patient                    |    ,b.drug                                |                                                  */
    /* start_date : date11.             |   from temp2 as a                         |                                                  */
    /* end_date : date9. drug :$8. ;    |   join have as b                          |                                                  */
    /* format start_date                |   on a.patient = b.patient                |                                                  */
    /*  end_date date11.;               |   and b.start_date <= a.en_dt             |                                                  */
    /* cards;                           |   and a.st_dt <= b.end_date               |                                                  */
    /* 1 19-Mar-98 26-Jul-98 amox       |   order by 1,2,3,4                        |                                                  */
    /* 1 19-Mar-98 18-Nov-98 cipro      |   ;                                       |                                                  */
    /* 1 19-Mar-98  1-Jun-05 zinc       | quit;                                     |                                                  */
    /* 1 19-Mar-98 15-Feb-09 flagyl     |                                           |                                                  */
    /* 1 27-Jul-98 24-Aug-05 cef        | proc transpose data=want                  |                                                  */
    /* 2 19-Nov-98  9-Jul-03 amox       |  out=want(drop=_name_);                   |                                                  */
    /* 2 10-Jul-03 31-Jul-06 cipro      |   by patient st_dt en_dt;                 |                                                  */
    /* 2  2-Jun-05 15-Feb-09 zinc       |   var drug;                               |                                                  */
    /* 2  1-Aug-06 16-Jul-18 flagyl     | run;                                      |                                                  */
    /* 3 16-Feb-09 16-Jul-18 cef        |                                           |                                                  */
    /* 3 16-Feb-09 25-Aug-19 sec        | data want;                                |                                                  */
    /* 4 16-Feb-09 16-Feb-09 xxx        |   set want;                               |                                                  */
    /* 4 16-Feb-09 16-Feb-09 yyy        |   drug = catx(",", of col:);              |                                                  */
    /* 4 16-Feb-09 17-Feb-09 zzz        |   drop col:;                              |                                                  */
    /* run;                             | run;                                      |                                                  */
    /*                                  | procedure print heading=vertical;         |                                                  */
    /*                                  | run;                                      |                                                  */
    /***********************************************************************************************************************************/*/
                                                                                                                                        /
    /*                   _
    (_)_ __  _ __  _   _| |_
    | | `_ \| `_ \| | | | __|
    | | | | | |_) | |_| | |_
    |_|_| |_| .__/ \__,_|\__|
     _      |_| ___ ____
    / |  _ __  |_ _|  _ \ __ _ _ __   __ _  ___  ___
    | | | `__|  | || |_) / _` | `_ \ / _` |/ _ \/ __|
    | | | |     | ||  _ < (_| | | | | (_| |  __/\__ \
    |_| |_|    |___|_| \_\__,_|_| |_|\__, |\___||___/
                                     |___/
    */

    libname sd1 "d:/sd1";
    data sd1.have;
    input id start
      end drug$;
    cards4;
    1  2 13 zin
    1  5 8  cip
    1  7 17 amo
    1  9 11 fla
    1 14 16 aax
    2  2  4 zin
    2  5 8  cip
    2  9 13 amo
    2 11 12 fla
    2 15 18 aax
    ;;;;
    run;quit;

    /**************************************************************************************************************************/
    /*   SD1.HAVE total obs=10                                                                                                */
    /*   ID    START    END    DRUG                                                                                           */
    /*                                                                                                                        */
    /*    1       2      13    zin                                                                                            */
    /*    1       5       8    cip                                                                                            */
    /*    1       7      17    amo                                                                                            */
    /*    1       9      11    fla                                                                                            */
    /*    1      14      16    aax                                                                                            */
    /*    2       2       4    zin                                                                                            */
    /*    2       5       8    cip                                                                                            */
    /*    2       9      13    amo                                                                                            */
    /*    2      11      12    fla                                                                                            */
    /*    2      15      18    aax                                                                                            */
    /**************************************************************************************************************************/

    %utl_rbeginx;
    parmcards4;
    library(data.table);
    library(IRanges);
    library(haven);
    library(sqldf);
    library(dplyr);
    source("c:/oto/fn_tosas9x.R")
    options(sqldf.dll = "d:/dll/sqlean.dll")
    have<-as.data.table(
     read_sas("d:/sd1/have.sas7bdat"));
    have

    want <- have[, {
     rng <- IRanges(START, END)
     hits <- findOverlaps(rng)
     hits <- hits[queryHits(hits)
          < subjectHits(hits)]
     if (length(hits)) {
       drugs <- .SD$DRUG
       qh <- queryHits(hits)
       sh <- subjectHits(hits)
       data.table(
         DRUG1 = paste0(qh,"(",drugs[qh],")"),
         DRUG2 = paste0(sh,"(",drugs[sh],")")
       )
     }
    }, by = ID]
    want
    fn_tosas9x(
          inp    = want
         ,outlib ="d:/sd1/"
         ,outdsn ="want"
         )
    ;;;;
    %utl_rendx;

    proc print data=sd1.want;
    run;quit;

    /**************************************************************************************************************************/
    /*  > want                  |                                                                                             */
    /*        ID  DRUG1  DRUG2  | iD    DRUG1     DRUG2                                                                       */
    /*                          |                                                                                             */
    /*  1:     1 1(zin) 2(cip)  |  1    1(zin)    2(cip)                                                                      */
    /*  2:     1 1(zin) 3(amo)  |  1    1(zin)    3(amo)                                                                      */
    /*  3:     1 1(zin) 4(fla)  |  1    1(zin)    4(fla)                                                                      */
    /*  4:     1 2(cip) 3(amo)  |  1    2(cip)    3(amo)                                                                      */
    /*  5:     1 3(amo) 4(fla)  |  1    3(amo)    4(fla)                                                                      */
    /*  6:     1 3(amo) 5(aax)  |  1    3(amo)    5(aax)                                                                      */
    /*  7:     2 3(amo) 4(fla)  |  2    3(amo)    4(fla)                                                                      */
    /**************************************************************************************************************************/

    /*                   _
    (_)_ __  _ __  _   _| |_
    | | `_ \| `_ \| | | | __|
    | | | | | |_) | |_| | |_
    |_|_| |_| .__/ \__,_|\__|
      ___   |_|
    |___ \   ___  __ _ ___
      __) | / __|/ _` / __|
     / __/  \__ \ (_| \__ \
    |_____| |___/\__,_|___/

    */

    data temp (keep=patient date);
      set have;
      date=start_date;   output;
      date=end_date+1;   output;
      format date date9.;
    run;

    proc sort data=temp nodupkey;
    by patient date;
    run;

    data temp2(rename=(date=st_dt
      d=en_dt));
      merge temp temp(rename
         = (patient=p date=d)
         firstobs=2);
      if patient=p;
      drop p;
      d=d-1;
    run;

    proc sql;
      create table want as
      select
        a.patient
       ,a.st_dt
       ,a.en_dt
       ,b.drug
      from temp2 as a
      join have as b
      on a.patient = b.patient
      and b.start_date <= a.en_dt
      and a.st_dt <= b.end_date
      order by 1,2,3,4
      ;
    quit;

    proc transpose data=want
     out=want(drop=_name_);
      by patient st_dt en_dt;
      var drug;
    run;

    data want;
      set want;
      drug = catx(",", of col:);
      drop col:;
    run;
    procedure print;
    run;

    /**************************************************************************************************************************/
    /*| PATIENT        ST_DT        EN_DT    DRUG                                                                             */
    /*|                                                                                                                       */
    /*|    1       19MAR1998    26JUL1998    amox,cipro,flagyl,zinc                                                           */
    /*|    1       27JUL1998    18NOV1998    cef,cipro,flagyl,zinc                                                            */
    /*|    1       19NOV1998    01JUN2005    cef,flagyl,zinc                                                                  */
    /*|    1       02JUN2005    24AUG2005    cef,flagyl                                                                       */
    /*|    1       25AUG2005    15FEB2009    flagyl                                                                           */
    /*|    2       19NOV1998    09JUL2003    amox                                                                             */
    /*|    2       10JUL2003    01JUN2005    cipro                                                                            */
    /*|    2       02JUN2005    31JUL2006    cipro,zinc                                                                       */
    /*|    2       01AUG2006    15FEB2009    flagyl,zinc                                                                      */
    /*|    2       16FEB2009    16JUL2018    flagyl                                                                           */
    /*|    3       16FEB2009    16JUL2018    cef,sec                                                                          */
    /*|    3       17JUL2018    25AUG2019    sec                                                                              */
    /*|    4       16FEB2009    16FEB2009    xxx,yyy,zzz                                                                      */
    /*|    4       17FEB2009    17FEB2009    zzz                                                                              */
    /**************************************************************************************************************************/

    /*              _
      ___ _ __   __| |
     / _ \ `_ \ / _` |
    |  __/ | | | (_| |
     \___|_| |_|\__,_|

    */

