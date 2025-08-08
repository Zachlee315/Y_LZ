@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'FOLDER ROOT root view'
@Metadata.ignorePropagatedAnnotations: true
define root view entity YFOLDER_R_0020 as select from YFOLDER_I_0020

{
    key FormId,
    Cycle,
    /* Associations */
    _Menu

}
