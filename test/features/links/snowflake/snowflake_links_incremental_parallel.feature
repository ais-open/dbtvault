Feature: [SF-LNK-PARALLEL] Links loaded using using duplicate parallel loads, and either default incremental or merge incremental materialisation

  @fixture.single_source_link
  Scenario: [SF-LNK-PARA-01] Load of mixed stage data into a non-existent link; load by a single process and
  default incremental materialisation
    Given the LINK table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1003        | AUS       | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | CRM    |
      | 1006        | DEU       | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | CRM    |
      | 1007        | ITA       | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
    And I stage the STG_CUSTOMER data
    And I load the LINK link
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1003        | AUS       | Bobby         | 2013-02-04   | 17-214-233-1215 | 1993-01-03 | CRM    |
      | 1006        | ROU       | Chaz          | 2018-04-13   | 17-214-233-1216 | 1993-01-03 | CRM    |
      | 1017        | ITA       | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-03 | CRM    |
      | 1008        | GBR       | Fred          | 2008-01-04   | 17-214-233-1218 | 1993-01-03 | CRM    |
      | 1009        | FRA       | Charles       | 1995-11-14   | 17-214-233-1219 | 1993-01-03 | CRM    |
      | 1010        | IND       | Aman          | 1983-07-05   | 17-214-233-1220 | 1993-01-03 | CRM    |
    And I stage the STG_CUSTOMER data
    When I load the LINK link with default incremental materialisation using 1 process and delay 0
    Then the LINK table should contain expected data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-02 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-02 | CRM    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-02 | CRM    |
      | md5('1006\|\|ROU') | md5('1006') | md5('ROU') | 1993-01-03 | CRM    |
      | md5('1017\|\|ITA') | md5('1017') | md5('ITA') | 1993-01-03 | CRM    |
      | md5('1008\|\|GBR') | md5('1008') | md5('GBR') | 1993-01-03 | CRM    |
      | md5('1009\|\|FRA') | md5('1009') | md5('FRA') | 1993-01-03 | CRM    |
      | md5('1010\|\|IND') | md5('1010') | md5('IND') | 1993-01-03 | CRM    |

  @fixture.single_source_link
  Scenario: [SF-LNK-PARA-02] Load of mixed stage data into a non-existent link; load simultaneously by two processes and
  default incremental materialisation: duplicate records are inserted
    Given the LINK table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1003        | AUS       | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | CRM    |
      | 1006        | DEU       | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | CRM    |
      | 1007        | ITA       | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
    And I stage the STG_CUSTOMER data
    And I load the LINK link
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1003        | AUS       | Bobby         | 2013-02-04   | 17-214-233-1215 | 1993-01-03 | CRM    |
      | 1006        | ROU       | Chaz          | 2018-04-13   | 17-214-233-1216 | 1993-01-03 | CRM    |
      | 1017        | ITA       | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-03 | CRM    |
      | 1008        | GBR       | Fred          | 2008-01-04   | 17-214-233-1218 | 1993-01-03 | CRM    |
      | 1009        | FRA       | Charles       | 1995-11-14   | 17-214-233-1219 | 1993-01-03 | CRM    |
      | 1010        | IND       | Aman          | 1983-07-05   | 17-214-233-1220 | 1993-01-03 | CRM    |
    And I stage the STG_CUSTOMER data
    When I load the LINK link with default incremental materialisation using 2 processes and delay 0
    Then the LINK table should contain expected data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-02 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-02 | CRM    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-02 | CRM    |
      | md5('1006\|\|ROU') | md5('1006') | md5('ROU') | 1993-01-03 | CRM    |
      | md5('1017\|\|ITA') | md5('1017') | md5('ITA') | 1993-01-03 | CRM    |
      | md5('1008\|\|GBR') | md5('1008') | md5('GBR') | 1993-01-03 | CRM    |
      | md5('1009\|\|FRA') | md5('1009') | md5('FRA') | 1993-01-03 | CRM    |
      | md5('1010\|\|IND') | md5('1010') | md5('IND') | 1993-01-03 | CRM    |
      | md5('1006\|\|ROU') | md5('1006') | md5('ROU') | 1993-01-03 | CRM    |
      | md5('1017\|\|ITA') | md5('1017') | md5('ITA') | 1993-01-03 | CRM    |
      | md5('1008\|\|GBR') | md5('1008') | md5('GBR') | 1993-01-03 | CRM    |
      | md5('1009\|\|FRA') | md5('1009') | md5('FRA') | 1993-01-03 | CRM    |
      | md5('1010\|\|IND') | md5('1010') | md5('IND') | 1993-01-03 | CRM    |

  @fixture.single_source_link
  Scenario: [SF-LNK-PARA-03] Load of mixed stage data into a non-existent link; load simultaneously by three processes and
  default incremental materialisation: duplicate records are inserted
    Given the LINK table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1003        | AUS       | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | CRM    |
      | 1006        | DEU       | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | CRM    |
      | 1007        | ITA       | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
    And I stage the STG_CUSTOMER data
    And I load the LINK link
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1003        | AUS       | Bobby         | 2013-02-04   | 17-214-233-1215 | 1993-01-03 | CRM    |
      | 1006        | ROU       | Chaz          | 2018-04-13   | 17-214-233-1216 | 1993-01-03 | CRM    |
      | 1017        | ITA       | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-03 | CRM    |
      | 1008        | GBR       | Fred          | 2008-01-04   | 17-214-233-1218 | 1993-01-03 | CRM    |
      | 1009        | FRA       | Charles       | 1995-11-14   | 17-214-233-1219 | 1993-01-03 | CRM    |
      | 1010        | IND       | Aman          | 1983-07-05   | 17-214-233-1220 | 1993-01-03 | CRM    |
    And I stage the STG_CUSTOMER data
    When I load the LINK link with default incremental materialisation using 3 processes and delay 0
    Then the LINK table should contain expected data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-02 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-02 | CRM    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-02 | CRM    |
      | md5('1006\|\|ROU') | md5('1006') | md5('ROU') | 1993-01-03 | CRM    |
      | md5('1017\|\|ITA') | md5('1017') | md5('ITA') | 1993-01-03 | CRM    |
      | md5('1008\|\|GBR') | md5('1008') | md5('GBR') | 1993-01-03 | CRM    |
      | md5('1009\|\|FRA') | md5('1009') | md5('FRA') | 1993-01-03 | CRM    |
      | md5('1010\|\|IND') | md5('1010') | md5('IND') | 1993-01-03 | CRM    |
      | md5('1006\|\|ROU') | md5('1006') | md5('ROU') | 1993-01-03 | CRM    |
      | md5('1017\|\|ITA') | md5('1017') | md5('ITA') | 1993-01-03 | CRM    |
      | md5('1008\|\|GBR') | md5('1008') | md5('GBR') | 1993-01-03 | CRM    |
      | md5('1009\|\|FRA') | md5('1009') | md5('FRA') | 1993-01-03 | CRM    |
      | md5('1010\|\|IND') | md5('1010') | md5('IND') | 1993-01-03 | CRM    |
      | md5('1006\|\|ROU') | md5('1006') | md5('ROU') | 1993-01-03 | CRM    |
      | md5('1017\|\|ITA') | md5('1017') | md5('ITA') | 1993-01-03 | CRM    |
      | md5('1008\|\|GBR') | md5('1008') | md5('GBR') | 1993-01-03 | CRM    |
      | md5('1009\|\|FRA') | md5('1009') | md5('FRA') | 1993-01-03 | CRM    |
      | md5('1010\|\|IND') | md5('1010') | md5('IND') | 1993-01-03 | CRM    |


  @fixture.single_source_link
  Scenario: [SF-LNK-PARA-04] Load of mixed stage data into a non-existent link; single parallel incremental load
    Given the LINK table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1003        | AUS       | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | CRM    |
      | 1006        | DEU       | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | CRM    |
      | 1007        | ITA       | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
    And I stage the STG_CUSTOMER data
    And I load the LINK link with merge incremental materialisation using 1 process and delay 0
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1003        | AUS       | Bobby         | 2013-02-04   | 17-214-233-1215 | 1993-01-03 | CRM    |
      | 1006        | ROU       | Chaz          | 2018-04-13   | 17-214-233-1216 | 1993-01-03 | CRM    |
      | 1017        | ITA       | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-03 | CRM    |
      | 1008        | GBR       | Fred          | 2008-01-04   | 17-214-233-1218 | 1993-01-03 | CRM    |
      | 1009        | FRA       | Charles       | 1995-11-14   | 17-214-233-1219 | 1993-01-03 | CRM    |
      | 1010        | IND       | Aman          | 1983-07-05   | 17-214-233-1220 | 1993-01-03 | CRM    |
    And I stage the STG_CUSTOMER data
    When I load the LINK link with merge incremental materialisation using 1 process and delay 0
    Then the LINK table should contain expected data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-02 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-02 | CRM    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-02 | CRM    |
      | md5('1006\|\|ROU') | md5('1006') | md5('ROU') | 1993-01-03 | CRM    |
      | md5('1017\|\|ITA') | md5('1017') | md5('ITA') | 1993-01-03 | CRM    |
      | md5('1008\|\|GBR') | md5('1008') | md5('GBR') | 1993-01-03 | CRM    |
      | md5('1009\|\|FRA') | md5('1009') | md5('FRA') | 1993-01-03 | CRM    |
      | md5('1010\|\|IND') | md5('1010') | md5('IND') | 1993-01-03 | CRM    |


  @fixture.single_source_link
  Scenario: [SF-LNK-PARA-05] Load of mixed stage data into a non-existent link; two parallel incremental loads
    Given the LINK table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1003        | AUS       | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | CRM    |
      | 1006        | DEU       | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | CRM    |
      | 1007        | ITA       | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
    And I stage the STG_CUSTOMER data
    And I load the LINK link with merge incremental materialisation using 2 processes and delay 0
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1003        | AUS       | Bobby         | 2013-02-04   | 17-214-233-1215 | 1993-01-03 | CRM    |
      | 1006        | ROU       | Chaz          | 2018-04-13   | 17-214-233-1216 | 1993-01-03 | CRM    |
      | 1017        | ITA       | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-03 | CRM    |
      | 1008        | GBR       | Fred          | 2008-01-04   | 17-214-233-1218 | 1993-01-03 | CRM    |
      | 1009        | FRA       | Charles       | 1995-11-14   | 17-214-233-1219 | 1993-01-03 | CRM    |
      | 1010        | IND       | Aman          | 1983-07-05   | 17-214-233-1220 | 1993-01-03 | CRM    |
    And I stage the STG_CUSTOMER data
    When I load the LINK link with merge incremental materialisation using 2 processes and delay 0
    Then the LINK table should contain expected data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-02 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-02 | CRM    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-02 | CRM    |
      | md5('1006\|\|ROU') | md5('1006') | md5('ROU') | 1993-01-03 | CRM    |
      | md5('1017\|\|ITA') | md5('1017') | md5('ITA') | 1993-01-03 | CRM    |
      | md5('1008\|\|GBR') | md5('1008') | md5('GBR') | 1993-01-03 | CRM    |
      | md5('1009\|\|FRA') | md5('1009') | md5('FRA') | 1993-01-03 | CRM    |
      | md5('1010\|\|IND') | md5('1010') | md5('IND') | 1993-01-03 | CRM    |


  @fixture.single_source_link
  Scenario: [SF-LNK-PARA-06] Load of mixed stage data into a non-existent link; two parallel incremental loads with short delay
    Given the LINK table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1003        | AUS       | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | CRM    |
      | 1006        | DEU       | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | CRM    |
      | 1007        | ITA       | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
    And I stage the STG_CUSTOMER data
    And I load the LINK link with merge incremental materialisation using 2 processes and delay 0.1
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1003        | AUS       | Bobby         | 2013-02-04   | 17-214-233-1215 | 1993-01-03 | CRM    |
      | 1006        | ROU       | Chaz          | 2018-04-13   | 17-214-233-1216 | 1993-01-03 | CRM    |
      | 1017        | ITA       | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-03 | CRM    |
      | 1008        | GBR       | Fred          | 2008-01-04   | 17-214-233-1218 | 1993-01-03 | CRM    |
      | 1009        | FRA       | Charles       | 1995-11-14   | 17-214-233-1219 | 1993-01-03 | CRM    |
      | 1010        | IND       | Aman          | 1983-07-05   | 17-214-233-1220 | 1993-01-03 | CRM    |
    And I stage the STG_CUSTOMER data
    When I load the LINK link with merge incremental materialisation using 2 processes and delay 0.1
    Then the LINK table should contain expected data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-02 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-02 | CRM    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-02 | CRM    |
      | md5('1006\|\|ROU') | md5('1006') | md5('ROU') | 1993-01-03 | CRM    |
      | md5('1017\|\|ITA') | md5('1017') | md5('ITA') | 1993-01-03 | CRM    |
      | md5('1008\|\|GBR') | md5('1008') | md5('GBR') | 1993-01-03 | CRM    |
      | md5('1009\|\|FRA') | md5('1009') | md5('FRA') | 1993-01-03 | CRM    |
      | md5('1010\|\|IND') | md5('1010') | md5('IND') | 1993-01-03 | CRM    |


  @fixture.single_source_link
  Scenario: [SF-LNK-PARA-07] Load of mixed stage data into a non-existent link; two parallel incremental loads with longer delay
    Given the LINK table does not exist
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1003        | AUS       | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | CRM    |
      | 1006        | DEU       | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | CRM    |
      | 1007        | ITA       | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
    And I stage the STG_CUSTOMER data
    And I load the LINK link with merge incremental materialisation using 2 processes and delay 1
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1003        | AUS       | Bobby         | 2013-02-04   | 17-214-233-1215 | 1993-01-03 | CRM    |
      | 1006        | ROU       | Chaz          | 2018-04-13   | 17-214-233-1216 | 1993-01-03 | CRM    |
      | 1017        | ITA       | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-03 | CRM    |
      | 1008        | GBR       | Fred          | 2008-01-04   | 17-214-233-1218 | 1993-01-03 | CRM    |
      | 1009        | FRA       | Charles       | 1995-11-14   | 17-214-233-1219 | 1993-01-03 | CRM    |
      | 1010        | IND       | Aman          | 1983-07-05   | 17-214-233-1220 | 1993-01-03 | CRM    |
    And I stage the STG_CUSTOMER data
    When I load the LINK link with merge incremental materialisation using 2 processes and delay 1
    Then the LINK table should contain expected data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-02 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-02 | CRM    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-02 | CRM    |
      | md5('1006\|\|ROU') | md5('1006') | md5('ROU') | 1993-01-03 | CRM    |
      | md5('1017\|\|ITA') | md5('1017') | md5('ITA') | 1993-01-03 | CRM    |
      | md5('1008\|\|GBR') | md5('1008') | md5('GBR') | 1993-01-03 | CRM    |
      | md5('1009\|\|FRA') | md5('1009') | md5('FRA') | 1993-01-03 | CRM    |
      | md5('1010\|\|IND') | md5('1010') | md5('IND') | 1993-01-03 | CRM    |


  @fixture.single_source_link
  Scenario: [SF-LNK-PARA-08] Load of mixed stage data into an empty link; two parallel incremental loads
    Given the LINK link is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1003        | AUS       | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | CRM    |
      | 1006        | DEU       | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | CRM    |
      | 1007        | ITA       | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
    And I stage the STG_CUSTOMER data
    And I load the LINK link with merge incremental materialisation using 2 processes and delay 0
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1003        | AUS       | Bobby         | 2013-02-04   | 17-214-233-1215 | 1993-01-03 | CRM    |
      | 1006        | ROU       | Chaz          | 2018-04-13   | 17-214-233-1216 | 1993-01-03 | CRM    |
      | 1017        | ITA       | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-03 | CRM    |
      | 1008        | GBR       | Fred          | 2008-01-04   | 17-214-233-1218 | 1993-01-03 | CRM    |
      | 1009        | FRA       | Charles       | 1995-11-14   | 17-214-233-1219 | 1993-01-03 | CRM    |
      | 1010        | IND       | Aman          | 1983-07-05   | 17-214-233-1220 | 1993-01-03 | CRM    |
    And I stage the STG_CUSTOMER data
    When I load the LINK link with merge incremental materialisation using 2 processes and delay 0
    Then the LINK table should contain expected data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-02 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-02 | CRM    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-02 | CRM    |
      | md5('1006\|\|ROU') | md5('1006') | md5('ROU') | 1993-01-03 | CRM    |
      | md5('1017\|\|ITA') | md5('1017') | md5('ITA') | 1993-01-03 | CRM    |
      | md5('1008\|\|GBR') | md5('1008') | md5('GBR') | 1993-01-03 | CRM    |
      | md5('1009\|\|FRA') | md5('1009') | md5('FRA') | 1993-01-03 | CRM    |
      | md5('1010\|\|IND') | md5('1010') | md5('IND') | 1993-01-03 | CRM    |


  @fixture.single_source_link
  Scenario: [SF-LNK-PARA-09] Load of mixed stage data into an empty link; two parallel incremental loads and short delay
    Given the LINK link is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1003        | AUS       | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | CRM    |
      | 1006        | DEU       | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | CRM    |
      | 1007        | ITA       | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
    And I stage the STG_CUSTOMER data
    And I load the LINK link with merge incremental materialisation using 2 processes and delay 0.1
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1003        | AUS       | Bobby         | 2013-02-04   | 17-214-233-1215 | 1993-01-03 | CRM    |
      | 1006        | ROU       | Chaz          | 2018-04-13   | 17-214-233-1216 | 1993-01-03 | CRM    |
      | 1017        | ITA       | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-03 | CRM    |
      | 1008        | GBR       | Fred          | 2008-01-04   | 17-214-233-1218 | 1993-01-03 | CRM    |
      | 1009        | FRA       | Charles       | 1995-11-14   | 17-214-233-1219 | 1993-01-03 | CRM    |
      | 1010        | IND       | Aman          | 1983-07-05   | 17-214-233-1220 | 1993-01-03 | CRM    |
    And I stage the STG_CUSTOMER data
    When I load the LINK link with merge incremental materialisation using 2 processes and delay 0.1
    Then the LINK table should contain expected data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-02 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-02 | CRM    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-02 | CRM    |
      | md5('1006\|\|ROU') | md5('1006') | md5('ROU') | 1993-01-03 | CRM    |
      | md5('1017\|\|ITA') | md5('1017') | md5('ITA') | 1993-01-03 | CRM    |
      | md5('1008\|\|GBR') | md5('1008') | md5('GBR') | 1993-01-03 | CRM    |
      | md5('1009\|\|FRA') | md5('1009') | md5('FRA') | 1993-01-03 | CRM    |
      | md5('1010\|\|IND') | md5('1010') | md5('IND') | 1993-01-03 | CRM    |


  @fixture.single_source_link
  Scenario: [SF-LNK-PARA-10] Load of mixed stage data into an empty link; two parallel incremental loads and longer delay
    Given the LINK link is empty
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1003        | AUS       | Bob           | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | CRM    |
      | 1006        | DEU       | Chad          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | CRM    |
      | 1007        | ITA       | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
    And I stage the STG_CUSTOMER data
    And I load the LINK link with merge incremental materialisation using 2 processes and delay 1
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1003        | AUS       | Bobby         | 2013-02-04   | 17-214-233-1215 | 1993-01-03 | CRM    |
      | 1006        | ROU       | Chaz          | 2018-04-13   | 17-214-233-1216 | 1993-01-03 | CRM    |
      | 1017        | ITA       | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-03 | CRM    |
      | 1008        | GBR       | Fred          | 2008-01-04   | 17-214-233-1218 | 1993-01-03 | CRM    |
      | 1009        | FRA       | Charles       | 1995-11-14   | 17-214-233-1219 | 1993-01-03 | CRM    |
      | 1010        | IND       | Aman          | 1983-07-05   | 17-214-233-1220 | 1993-01-03 | CRM    |
    And I stage the STG_CUSTOMER data
    When I load the LINK link with merge incremental materialisation using 2 processes and delay 1
    Then the LINK table should contain expected data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-02 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-02 | CRM    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-02 | CRM    |
      | md5('1006\|\|ROU') | md5('1006') | md5('ROU') | 1993-01-03 | CRM    |
      | md5('1017\|\|ITA') | md5('1017') | md5('ITA') | 1993-01-03 | CRM    |
      | md5('1008\|\|GBR') | md5('1008') | md5('GBR') | 1993-01-03 | CRM    |
      | md5('1009\|\|FRA') | md5('1009') | md5('FRA') | 1993-01-03 | CRM    |
      | md5('1010\|\|IND') | md5('1010') | md5('IND') | 1993-01-03 | CRM    |


  @fixture.single_source_link
  Scenario: [SF-LNK-PARA-11] Load of mixed stage data into an existing link; two parallel incremental loads
    Given the LINK link is already populated with data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-02 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-02 | CRM    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-02 | CRM    |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1003        | AUS       | Bobby         | 2013-02-04   | 17-214-233-1215 | 1993-01-03 | CRM    |
      | 1006        | ROU       | Chaz          | 2018-04-13   | 17-214-233-1216 | 1993-01-03 | CRM    |
      | 1017        | ITA       | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-03 | CRM    |
      | 1008        | GBR       | Fred          | 2008-01-04   | 17-214-233-1218 | 1993-01-03 | CRM    |
      | 1009        | FRA       | Charles       | 1995-11-14   | 17-214-233-1219 | 1993-01-03 | CRM    |
      | 1010        | IND       | Aman          | 1983-07-05   | 17-214-233-1220 | 1993-01-03 | CRM    |
    And I stage the STG_CUSTOMER data
    When I load the LINK link with merge incremental materialisation using 2 processes and delay 0
    Then the LINK table should contain expected data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-02 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-02 | CRM    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-02 | CRM    |
      | md5('1006\|\|ROU') | md5('1006') | md5('ROU') | 1993-01-03 | CRM    |
      | md5('1017\|\|ITA') | md5('1017') | md5('ITA') | 1993-01-03 | CRM    |
      | md5('1008\|\|GBR') | md5('1008') | md5('GBR') | 1993-01-03 | CRM    |
      | md5('1009\|\|FRA') | md5('1009') | md5('FRA') | 1993-01-03 | CRM    |
      | md5('1010\|\|IND') | md5('1010') | md5('IND') | 1993-01-03 | CRM    |


  @fixture.single_source_link
  Scenario: [SF-LNK-PARA-12] Load of mixed stage data into an existing link; two parallel incremental loads and short delay
    Given the LINK link is already populated with data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-02 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-02 | CRM    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-02 | CRM    |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1003        | AUS       | Bobby         | 2013-02-04   | 17-214-233-1215 | 1993-01-03 | CRM    |
      | 1006        | ROU       | Chaz          | 2018-04-13   | 17-214-233-1216 | 1993-01-03 | CRM    |
      | 1017        | ITA       | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-03 | CRM    |
      | 1008        | GBR       | Fred          | 2008-01-04   | 17-214-233-1218 | 1993-01-03 | CRM    |
      | 1009        | FRA       | Charles       | 1995-11-14   | 17-214-233-1219 | 1993-01-03 | CRM    |
      | 1010        | IND       | Aman          | 1983-07-05   | 17-214-233-1220 | 1993-01-03 | CRM    |
    And I stage the STG_CUSTOMER data
    When I load the LINK link with merge incremental materialisation using 2 processes and delay 0.1
    Then the LINK table should contain expected data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-02 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-02 | CRM    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-02 | CRM    |
      | md5('1006\|\|ROU') | md5('1006') | md5('ROU') | 1993-01-03 | CRM    |
      | md5('1017\|\|ITA') | md5('1017') | md5('ITA') | 1993-01-03 | CRM    |
      | md5('1008\|\|GBR') | md5('1008') | md5('GBR') | 1993-01-03 | CRM    |
      | md5('1009\|\|FRA') | md5('1009') | md5('FRA') | 1993-01-03 | CRM    |
      | md5('1010\|\|IND') | md5('1010') | md5('IND') | 1993-01-03 | CRM    |


  @fixture.single_source_link
  Scenario: [SF-LNK-PARA-13] Load of mixed stage data into an existing link; two parallel incremental loads and longer delay
    Given the LINK link is already populated with data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-02 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-02 | CRM    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-02 | CRM    |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1003        | AUS       | Bobby         | 2013-02-04   | 17-214-233-1215 | 1993-01-03 | CRM    |
      | 1006        | ROU       | Chaz          | 2018-04-13   | 17-214-233-1216 | 1993-01-03 | CRM    |
      | 1017        | ITA       | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-03 | CRM    |
      | 1008        | GBR       | Fred          | 2008-01-04   | 17-214-233-1218 | 1993-01-03 | CRM    |
      | 1009        | FRA       | Charles       | 1995-11-14   | 17-214-233-1219 | 1993-01-03 | CRM    |
      | 1010        | IND       | Aman          | 1983-07-05   | 17-214-233-1220 | 1993-01-03 | CRM    |
    And I stage the STG_CUSTOMER data
    When I load the LINK link with merge incremental materialisation using 2 processes and delay 1
    Then the LINK table should contain expected data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-02 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-02 | CRM    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-02 | CRM    |
      | md5('1006\|\|ROU') | md5('1006') | md5('ROU') | 1993-01-03 | CRM    |
      | md5('1017\|\|ITA') | md5('1017') | md5('ITA') | 1993-01-03 | CRM    |
      | md5('1008\|\|GBR') | md5('1008') | md5('GBR') | 1993-01-03 | CRM    |
      | md5('1009\|\|FRA') | md5('1009') | md5('FRA') | 1993-01-03 | CRM    |
      | md5('1010\|\|IND') | md5('1010') | md5('IND') | 1993-01-03 | CRM    |


  @fixture.single_source_link
  Scenario: [SF-LNK-PARA-14] Load of mixed stage data into an existing link; multiple parallel incremental loads
  mixing things up a little
    Given the LINK link is already populated with data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-01 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-01 | CRM    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-01 | CRM    |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1003        | AUS       | Bobby         | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | CRM    |
      | 1006        | ROU       | Chaz          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | CRM    |
      | 1017        | ITA       | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
      | 1008        | GBR       | Fred          | 2008-01-04   | 17-214-233-1218 | 1993-01-02 | CRM    |
      | 1009        | FRA       | Charles       | 1995-11-14   | 17-214-233-1219 | 1993-01-02 | CRM    |
      | 1010        | IND       | Aman          | 1983-07-05   | 17-214-233-1220 | 1993-01-02 | CRM    |
    And I stage the STG_CUSTOMER data
    And I load the LINK link with merge incremental materialisation using 11 processes and delay 0
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1008        | GBR       | Fred          | 2008-01-04   | 17-214-233-1218 | 1993-01-03 | CRM    |
      | 1009        | FRA       | Charles       | 1995-11-14   | 17-214-233-1219 | 1993-01-03 | CRM    |
      | 1010        | IND       | Aman          | 1983-07-05   | 17-214-233-1220 | 1993-01-03 | CRM    |
    And I stage the STG_CUSTOMER data
    And I load the LINK link with merge incremental materialisation using 9 processes and delay 0.001
    Then the LINK table should contain expected data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-01 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-01 | CRM    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-01 | CRM    |
      | md5('1006\|\|ROU') | md5('1006') | md5('ROU') | 1993-01-02 | CRM    |
      | md5('1017\|\|ITA') | md5('1017') | md5('ITA') | 1993-01-02 | CRM    |
      | md5('1008\|\|GBR') | md5('1008') | md5('GBR') | 1993-01-02 | CRM    |
      | md5('1009\|\|FRA') | md5('1009') | md5('FRA') | 1993-01-02 | CRM    |
      | md5('1010\|\|IND') | md5('1010') | md5('IND') | 1993-01-02 | CRM    |


  @fixture.single_source_link
  Scenario: [SF-LNK-PARA-15] Load of mixed stage data into an existing link; single incremental loads
  mixing things up a little
    Given the LINK link is already populated with data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-01 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-01 | CRM    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-01 | CRM    |
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1003        | AUS       | Bobby         | 2013-02-04   | 17-214-233-1215 | 1993-01-02 | CRM    |
      | 1006        | ROU       | Chaz          | 2018-04-13   | 17-214-233-1216 | 1993-01-02 | CRM    |
      | 1017        | ITA       | Dom           | 1990-01-01   | 17-214-233-1217 | 1993-01-02 | CRM    |
      | 1008        | GBR       | Fred          | 2008-01-04   | 17-214-233-1218 | 1993-01-02 | CRM    |
      | 1009        | FRA       | Charles       | 1995-11-14   | 17-214-233-1219 | 1993-01-02 | CRM    |
      | 1010        | IND       | Aman          | 1983-07-05   | 17-214-233-1220 | 1993-01-02 | CRM    |
    And I stage the STG_CUSTOMER data
    And I load the LINK link using merge incremental materialisation
    And the RAW_STAGE table contains data
      | CUSTOMER_ID | NATION_ID | CUSTOMER_NAME | CUSTOMER_DOB | CUSTOMER_PHONE  | LOAD_DATE  | SOURCE |
      | 1008        | GBR       | Fred          | 2008-01-04   | 17-214-233-1218 | 1993-01-03 | CRM    |
      | 1009        | FRA       | Charles       | 1995-11-14   | 17-214-233-1219 | 1993-01-03 | CRM    |
      | 1010        | IND       | Aman          | 1983-07-05   | 17-214-233-1220 | 1993-01-03 | CRM    |
    And I stage the STG_CUSTOMER data
    And I load the LINK link using merge incremental materialisation
    Then the LINK table should contain expected data
      | CUSTOMER_NATION_PK | CUSTOMER_FK | NATION_FK  | LOAD_DATE  | SOURCE |
      | md5('1003\|\|AUS') | md5('1003') | md5('AUS') | 1993-01-01 | CRM    |
      | md5('1006\|\|DEU') | md5('1006') | md5('DEU') | 1993-01-01 | CRM    |
      | md5('1007\|\|ITA') | md5('1007') | md5('ITA') | 1993-01-01 | CRM    |
      | md5('1006\|\|ROU') | md5('1006') | md5('ROU') | 1993-01-02 | CRM    |
      | md5('1017\|\|ITA') | md5('1017') | md5('ITA') | 1993-01-02 | CRM    |
      | md5('1008\|\|GBR') | md5('1008') | md5('GBR') | 1993-01-02 | CRM    |
      | md5('1009\|\|FRA') | md5('1009') | md5('FRA') | 1993-01-02 | CRM    |
      | md5('1010\|\|IND') | md5('1010') | md5('IND') | 1993-01-02 | CRM    |