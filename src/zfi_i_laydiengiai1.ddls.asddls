@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'lấy diễn giải mua hàng 1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFI_I_laydiengiai1 as select distinct from I_OperationalAcctgDocItem as oadi
//    inner join            I_JournalEntry    as je         on  oadi.CompanyCode        = je.CompanyCode
//                                                                       and oadi.AccountingDocument = je.AccountingDocument
//                                                                       and oadi.FiscalYear         = je.FiscalYear
//left outer join I_ProductDescription as text on text.Language = 'E'
//                                    and text.Product = oadi.Product
left outer join I_ProductText as prdt on prdt.Product = oadi.Material
                                    and  prdt.Language = $session.system_language      
left outer join I_UnitOfMeasure as uom on oadi.BaseUnit =  uom.UnitOfMeasure                                                                   
{
    key oadi.CompanyCode,
    key oadi.AccountingDocument,
    key oadi.FiscalYear,
    key oadi.AccountingDocumentItem,
    key oadi.TaxCode,
    oadi.FinancialAccountType,
    oadi.DocumentItemText,
    oadi.Material,
//    je.AccountingDocumentHeaderText,
//    case when oadi.DocumentItemText <> ''
//        then oadi.DocumentItemText
//        else je.AccountingDocumentHeaderText
//      end as DienGiai1
    prdt.ProductName as DienGiai1,
    oadi.BaseUnit ,
    uom.UnitOfMeasure_E,
    @Semantics.quantity.unitOfMeasure: 'BaseUnit'
    oadi.Quantity as SoLuong1
}
where oadi.FinancialAccountType  = 'S' and oadi.PurchasingDocument = ''
