%let pgm=utl-identify-overlapping-drug-exposures-of-at-least-one-day-using-r-iranges-package;

%stop_submission;

Identify overlapping drug exposures of at least one day using r iranges package

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


/**************************************************************************************************************************/
/* INPUT                 | PROCESS                                           | OUTPUT                                     */
/* =====                 | =======                                           | ======                                     */
/* SD1.HAVE              | %utl_rbeginx;                                     | R                                          */
/*                       | parmcards4;                                       |  ID  DRUG1  DRUG2                          */
/* ID START END DRUG     | library(data.table);                              |                                            */
/*                       | library(IRanges);                                 |   1 1(zin) 2(cip)                          */
/* 1   02   13   zin     | library(haven);                                   |   1 1(zin) 3(amo)                          */
/* 1   05   08   cip     | library(sqldf);                                   |   1 1(zin) 4(fla)                          */
/* 1   07   17   amo     | library(dplyr);                                   |   1 2(cip) 3(amo)                          */
/* 1   09   11   fla     | source("c:/oto/fn_tosas9x.R")                     |   1 3(amo) 4(fla)                          */
/* 1   14   16   aax     | options(sqldf.dll = "d:/dll/sqlean.dll")          |   1 3(amo) 5(aax)                          */
/* 2   02   04   zin     | have<-as.data.table(                              |   2 3(amo) 4(fla)                          */
/* 2   05   08   cip     |  read_sas("d:/sd1/have.sas7bdat"));               |                                            */
/* 2   09   13   amo     | have                                              |  SAS                                       */
/* 2   11   12   fla     |                                                   |   ID DRUG1  DRUG2                          */
/* 2   15   18   aax     | want <- have[, {                                  |                                            */
/*                       |  rng <- IRanges(START, END)                       |    1 1(zin) 2(cip)                         */
/* libname sd1 "d:/sd1"; |  hits <- findOverlaps(rng)                        |    1 1(zin) 3(amo)                         */
/* data sd1.have;        |  hits <- hits[queryHits(hits)                     |    1 1(zin) 4(fla)                         */
/* input id start        |       < subjectHits(hits)]                        |    1 2(cip) 3(amo)                         */
/*   end drug$;          |  if (length(hits)) {                              |    1 3(amo) 4(fla)                         */
/* cards4;               |    drugs <- .SD$DRUG                              |    1 3(amo) 5(aax)                         */
/* 1  2 13 zin           |    qh <- queryHits(hits)                          |    2 3(amo) 4(fla)                         */
/* 1  5 8  cip           |    sh <- subjectHits(hits)                        |                                            */
/* 1  7 17 amo           |    data.table(                                    |                                            */
/* 1  9 11 fla           |      DRUG1 = paste0(qh,"(",drugs[qh],")"),        |                                            */
/* 1 14 16 aax           |      DRUG2 = paste0(sh,"(",drugs[sh],")")         |                                            */
/* 2  2  4 zin           |    )                                              |                                            */
/* 2  5 8  cip           |  }                                                |                                            */
/* 2  9 13 amo           | }, by = ID]                                       |                                            */
/* 2 11 12 fla           | want                                              |                                            */
/* 2 15 18 aax           | fn_tosas9x(                                       |                                            */
/* ;;;;                  |       inp    = want                               |                                            */
/* run;quit;             |      ,outlib ="d:/sd1/"                           |                                            */
/*                       |      ,outdsn ="want"                              |                                            */
/*                       |      )                                            |                                            */
/*                       | ;;;;                                              |                                            */
/*                       | %utl_rendx;                                       |                                            */
/*                       |                                                   |                                            */
/*                       | proc print data=sd1.want;                         |                                            */
/*                       | run;quit;                                         |                                            */
/**************************************************************************************************************************/

/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
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

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
