SAS Forum: Using SAS passthtru to excel to rename problematic column names for import

Post title SAS 9.2 and SAS 9.4 create different variable names when import excel files.

My suggestion is to use SAS passthru to excel to rename the problematic names


   WORKING CODE

      create
          table hba1c as
      select
           *
          from connection to Excel
          (
           Select
               `HbA1c (fraction)` as HbA1c   ** NOTE THE BACKTICKS;
               ,sex
               ,age
           from
              [hba1c$]
          );

https://goo.gl/wqVKeA
https://communities.sas.com/t5/Base-SAS-Programming/SAS-9-2-and-SAS-9-4-create-different-variable-names-when-import/m-p/401855


HAVE  (Excel sheet with bad column name )
=========================================

   d:/xls/hba1c.xlsx

       +---------------------------------------------------------------------+
        |     A          |    B         |     C        |    D       |    E       |
        +-------------------------+----------------|-------------------------+
     1  |HbA1c (fraction)|   SEX        |    AGE       |  HEIGHT    |  WEIGHT    |
        +---------------------------+--------------+------------+------------+
     2  | ALFRED         |    M         |    14        |    69      |  112.5     |
        +---------------------------+--------------+------------+------------+
         ...
        +---------------------------+--------------+------------+------------+
     20 | WILLIAM        |    M         |    15        |   66.5     |  112       |
        +------------+--------------+--------------+------------+------------+

   [HBA1C$]



WANT   SAS dataset with nice names)
====================================

   WORK.WANT total obs=19

    Obs    HBA1C       SEX        AGE       HEIGHT    WEIGHT

      1    Alfred       M           14        69.0      112.5
      2    Alice        F           13        56.5       84.0
      3    Barbara      F           13        65.3       98.0
      4    Carol        F           14        62.8      102.5
      5    Henry        M           14        63.5      102.5


*                _               _
 _ __ ___   __ _| | _____  __  _| |_____  __
| '_ ` _ \ / _` | |/ / _ \ \ \/ / / __\ \/ /
| | | | | | (_| |   <  __/  >  <| \__ \>  <
|_| |_| |_|\__,_|_|\_\___| /_/\_\_|___/_/\_\

;

options validvarname=any;
%utlfkil(d:/xls/hba1c.xlsx);
libname xel "d:/xls/hba1c.xlsx";
data xel.hba1c;
  set sashelp.class(
     rename=( keep=name sex
     name='HbA1c (fraction)'n
  ));
run;quit;
libname xel clear;
options validvarname=upcase;

     age='-Glucose (mg/dl)'n
*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __
/ __|/ _ \| | | | | __| |/ _ \| '_ \
\__ \ (_) | | |_| | |_| | (_) | | | |
|___/\___/|_|\__,_|\__|_|\___/|_| |_|

;

proc datasets lib=work kill;
run;quit;

%symdel rens / nowarn;

proc sql dquote=ansi;
 connect to excel (Path="d:/xls/hba1c.xlsx" mixed=yes);
    create
        table hba1c as
    select
         *
        from connection to Excel
        (
         Select
             `HbA1c (fraction)` as HbA1c
             ,sex
             ,age
         from
            [hba1c$]
        );
    disconnect from Excel;
Quit;


/*
1568  %symdel rens / nowarn;
1569  proc sql dquote=ansi;
1570   connect to excel (Path="d:/xls/hba1c.xlsx" mixed=yes);
NOTE: Data source is connected in READ ONLY mode.

1571      create
1572          table hba1c as
1573      select
1574           *
1575          from connection to Excel
1576          (
1577           Select
1578               `HbA1c (fraction)` as HbA1c
1579               ,sex
1580               ,age
1581           from
1582              [hba1c$]
1583          );
NOTE: Table WORK."HBA1C" created, with 19 rows and 3 columns.

1584      disconnect from Excel;
1585  Quit;
NOTE: PROCEDURE SQL used (Total process time):
*/


