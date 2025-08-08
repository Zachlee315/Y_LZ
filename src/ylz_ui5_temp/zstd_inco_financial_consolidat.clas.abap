class ZSTD_INCO_FINANCIAL_CONSOLIDAT definition
  public
  inheriting from CL_PROXY_CLIENT
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !DESTINATION type ref to IF_PROXY_DESTINATION optional
      !LOGICAL_PORT_NAME type PRX_LOGICAL_PORT_NAME optional
    preferred parameter LOGICAL_PORT_NAME
    raising
      CX_AI_SYSTEM_FAULT .
  methods REPORTED_FINANCIAL_DATA_CREATE
    importing
      !INPUT type ZSTD_INREPORTED_FINANCIAL_DAT6
    raising
      CX_AI_SYSTEM_FAULT .
protected section.
private section.
ENDCLASS.



CLASS ZSTD_INCO_FINANCIAL_CONSOLIDAT IMPLEMENTATION.


  method CONSTRUCTOR.

  super->constructor(
    class_name          = 'ZSTD_INCO_FINANCIAL_CONSOLIDAT'
    logical_port_name   = logical_port_name
    destination         = destination
  ).

  endmethod.


  method REPORTED_FINANCIAL_DATA_CREATE.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'REPORTED_FINANCIAL_DATA_CREATE'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.
ENDCLASS.
