@EndUserText.label: 'SH Account Group Supplier'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZFI_ACCOUNTGROUP_SUP_SH as select from I_SupplierAccountGroupText
{
    key SupplierAccountGroup,
    key Language,
    AccountGroupName
}where Language = 'E' 

