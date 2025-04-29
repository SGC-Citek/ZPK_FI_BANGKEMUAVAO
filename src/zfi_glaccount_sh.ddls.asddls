@EndUserText.label: 'Search help for GLAccount'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZFI_GLACCOUNT_SH  as select distinct from       I_OperationalAcctgDocItem   as oadi    
{ 
  key  oadi.GLAccount
}
