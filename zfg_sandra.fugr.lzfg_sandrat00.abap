*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 21.02.2020 at 18:40:21
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZTCAPACITY......................................*
DATA:  BEGIN OF STATUS_ZTCAPACITY                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTCAPACITY                    .
CONTROLS: TCTRL_ZTCAPACITY
            TYPE TABLEVIEW USING SCREEN '0007'.
*...processing: ZTDISTANCES.....................................*
DATA:  BEGIN OF STATUS_ZTDISTANCES                   .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTDISTANCES                   .
CONTROLS: TCTRL_ZTDISTANCES
            TYPE TABLEVIEW USING SCREEN '0003'.
*...processing: ZTSHORT.........................................*
DATA:  BEGIN OF STATUS_ZTSHORT                       .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTSHORT                       .
CONTROLS: TCTRL_ZTSHORT
            TYPE TABLEVIEW USING SCREEN '0013'.
*...processing: ZTSTORES........................................*
DATA:  BEGIN OF STATUS_ZTSTORES                      .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTSTORES                      .
CONTROLS: TCTRL_ZTSTORES
            TYPE TABLEVIEW USING SCREEN '0001'.
*...processing: ZTVEHICLE_TYPES.................................*
DATA:  BEGIN OF STATUS_ZTVEHICLE_TYPES               .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTVEHICLE_TYPES               .
CONTROLS: TCTRL_ZTVEHICLE_TYPES
            TYPE TABLEVIEW USING SCREEN '0009'.
*.........table declarations:.................................*
TABLES: *ZTCAPACITY                    .
TABLES: *ZTDISTANCES                   .
TABLES: *ZTSHORT                       .
TABLES: *ZTSTORES                      .
TABLES: *ZTVEHICLE_TYPES               .
TABLES: ZTCAPACITY                     .
TABLES: ZTDISTANCES                    .
TABLES: ZTSHORT                        .
TABLES: ZTSTORES                       .
TABLES: ZTVEHICLE_TYPES                .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
