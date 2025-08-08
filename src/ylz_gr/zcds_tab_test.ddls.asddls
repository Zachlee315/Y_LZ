@EndUserText.label: 'TEST'
define table function ZCDS_TAB_TEST

returns {
  client : abap.clnt;
  BATCH : charg_d;
  
}
implemented by method zlz_gr_test_class=>CONCAT_TEST;