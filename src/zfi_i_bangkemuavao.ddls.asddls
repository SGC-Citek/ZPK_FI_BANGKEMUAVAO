@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Bảng kê hoá đơn,chứng từ,dịch vụ mua vào'
@Search.searchable: true
@Metadata.allowExtensions: true
define root view entity ZFI_I_BANGKEMUAVAO
  with parameters
    @Environment.systemField:#SYSTEM_DATE
    @EndUserText.label: 'From Date'
    FromDate : vdm_v_key_date,
    @Environment.systemField:#SYSTEM_DATE
    @EndUserText.label: 'To Date'
    ToDate   : vdm_v_key_date
  as select distinct from I_JournalEntry               as je
    inner join            I_OperationalAcctgDocItem    as oadi         on  oadi.CompanyCode        = je.CompanyCode
                                                                       and oadi.AccountingDocument = je.AccountingDocument
                                                                       and oadi.FiscalYear         = je.FiscalYear
    left outer join       I_OperationalAcctgDocTaxItem as taxAmount    on  taxAmount.CompanyCode        = je.CompanyCode
                                                                       and taxAmount.AccountingDocument = je.AccountingDocument
                                                                       and taxAmount.FiscalYear         = je.FiscalYear
                                                                       and (taxAmount.TaxCode            = oadi.TaxCode or oadi.TaxCode = '**' or oadi.TaxCode = '')
    left outer join       ZFI_I_GETNAME_UUTIEN1        as uuTien1      on uuTien1.AccountingDocument = je.AccountingDocument
                                                                       and uuTien1.CompanyCode        = je.CompanyCode
                                                                       and uuTien1.FiscalYear         = je.FiscalYear
//                                                                       and uuTien1.AccountingDocumentItem = oadi.AccountingDocumentItem
    left outer join       ZFI_GETNAME_UUTIEN2          as uuTien2      on  uuTien2.AccountingDocument = je.AccountingDocument
                                                                       and uuTien2.CompanyCode        = je.CompanyCode
                                                                       and uuTien2.FiscalYear         = je.FiscalYear
//                                                                      and uuTien2.AccountingDocumentItem = oadi.AccountingDocumentItem
    left outer join       ZFI_I_GETNAME_UUTIEN3        as uuTien3      on  uuTien3.AccountingDocument = je.AccountingDocument
                                                                       and uuTien3.CompanyCode        = je.CompanyCode
                                                                       and uuTien3.FiscalYear         = je.FiscalYear
//                                                                      and uuTien3.AccountingDocumentItem = oadi.AccountingDocumentItem
    left outer join       ZFI_I_GETNAME_UUTIEN4        as uuTien4      on  uuTien4.AccountingDocument = je.AccountingDocument
                                                                       and uuTien4.CompanyCode        = je.CompanyCode
                                                                       and uuTien4.FiscalYear         = je.FiscalYear
//                                                                      and uuTien4.AccountingDocumentItem = oadi.AccountingDocumentItem
//    left outer join       ZFI_I_GETNAME_UUTIEN5        as uuTien5      on  uuTien5.AccountingDocument = je.AccountingDocument
//                                                                       and uuTien5.CompanyCode        = je.CompanyCode
//                                                                       and uuTien5.FiscalYear         = je.FiscalYear
//                                                                      and uuTien5.AccountingDocumentItem = oadi.AccountingDocumentItem

    left outer join       ZFI_I_LAYDIENGIAI            as dienGiai     on  dienGiai.AccountingDocument     = je.AccountingDocument
                                                                       and dienGiai.CompanyCode            = je.CompanyCode
                                                                       and dienGiai.FiscalYear             = je.FiscalYear
                                                                       and dienGiai.AccountingDocumentItem = oadi.AccountingDocumentItem
                                                                       and dienGiai.TaxCode = taxAmount.TaxCode

    left outer join       ZFI_I_laydiengiai1           as dienGiai1    on  dienGiai1.AccountingDocument     = je.AccountingDocument
                                                                       and dienGiai1.CompanyCode            = je.CompanyCode
                                                                       and dienGiai1.FiscalYear             = je.FiscalYear
                                                                       and dienGiai1.AccountingDocumentItem = oadi.AccountingDocumentItem
                                                                       and dienGiai1.TaxCode = taxAmount.TaxCode
//
//    left outer join       ZFI_I_laydiengiai2           as dienGiai2    on  dienGiai2.AccountingDocument     = je.AccountingDocument
//                                                                       and dienGiai2.CompanyCode            = je.CompanyCode
//                                                                       and dienGiai2.FiscalYear             = je.FiscalYear
//                                                                       and dienGiai2.AccountingDocumentItem = oadi.AccountingDocumentItem
    left outer join       ZFI_I_GETMATERIAL            as matHangExcel on  matHangExcel.AccountingDocument     = je.AccountingDocument
                                                                       and matHangExcel.CompanyCode            = je.CompanyCode
                                                                       and matHangExcel.FiscalYear             = je.FiscalYear
                                                                       and matHangExcel.AccountingDocumentItem = oadi.AccountingDocumentItem

    left outer join       ZFI_TAXCODE                  as taxCode      on taxCode.Taxcode = taxAmount.TaxCode

    left outer join       I_ProductDescription         as text         on  text.Language = 'E'
                                                                       and text.Product  = oadi.Product
     
    left outer join   I_CompanyCode  as compc on    compc.CompanyCode =  je.CompanyCode
    left outer join   I_OrganizationAddress as compadd on compadd.AddressID = compc.AddressID                                               

{
         @Search.defaultSearchElement: true
                 @Consumption.valueHelpDefinition: [{ entity : { name: 'I_CompanyCodeStdVH', element: 'CompanyCode'},
        distinctValues : true
        }]
  key    je.CompanyCode,
  key    je.FiscalYear,
  key    je.AccountingDocument,
  key    oadi.AccountingDocumentItem,
  key    taxAmount.TaxCode,
         dienGiai.ConditionType,
         dienGiai.Product,
         taxAmount.CompanyCodeCurrency,
         je._CompanyCode.CompanyCodeName, //bc2
         je._CompanyCode.VATRegistration, //bc3
         je.DocumentReferenceID, //bc7
         case 
            when je.PostingDate >= '20240101' and je.PostingDate <= '20240131' and je.AccountingDocumentHeaderText like 'Hoá đơn mua hàng Zeta'
                then je.PostingDate
                else  je.DocumentDate                 
         end as NgayPhatHanh, //bc8
         je.AccountingDocumentHeaderText,
         je.DocumentDate,
         @Search.defaultSearchElement: true
         je.PostingDate,
         case
             when uuTien1.name1 <> ''
                 then uuTien1.name1
             when uuTien2.name2 <> ''
                 then uuTien2.name2
             when uuTien3.name3 <> '' 
                 then uuTien3.name3
             else
                  uuTien4.name4
         end                             as TenNguoiBan,
         case
             when uuTien1.Tax1 <> ''
                 then uuTien1.Tax1
             when uuTien2.Tax2 <> ''
                 then uuTien2.Tax2
             when uuTien3.Tax3 <> '' 
                 then uuTien3.Tax3
             else
                  uuTien4.Tax4
         end                             as MSTNguoiBan,
         case
             when uuTien1.Diachi1 <> ''
                 then uuTien1.Diachi1
             when uuTien2.Diachi2 <> ''
                 then uuTien2.Diachi2
             when uuTien3.Diachi3 <> '' 
                 then uuTien3.Diachi3
             else
                 uuTien4.Diachi4
         end                             as Diachi,

        case
            when oadi.PurchasingDocument = '' and dienGiai.DienGiai = ''
                then cast('' as abap.char(1))
            else                             
                 case
                     when dienGiai.DienGiai <> ''
                         then dienGiai.DienGiai
                     else 
                          dienGiai1.DienGiai1
                 end                                 
       end as DienGiai,
//       dienGiai.SoLuong as SoLuong,
//        dienGiai.PurchaseOrderQuantityUnit as DVT,
        case 
            when dienGiai.UnitOfMeasure_E <> ''
                then   dienGiai.UnitOfMeasure_E 
            else
                dienGiai1.UnitOfMeasure_E
        end as  DVT_E,
        case 
            when dienGiai.PurchaseOrderQuantityUnit <> ''
                then   dienGiai.PurchaseOrderQuantityUnit 
            else
                dienGiai1.BaseUnit
        end as  DVT,
        @Semantics.quantity.unitOfMeasure: 'DVT'
        case 
            when dienGiai.SoLuong <> 0
                then dienGiai.SoLuong
            else
                dienGiai1.SoLuong1
        end as SoLuong,
//       dienGiai1.DienGiai1 as DienGiaiText,
                     @Search.defaultSearchElement: true
                 @Consumption.valueHelpDefinition: [{ entity : { name: 'ZFI_ACCOUNTGROUP_SUP_SH', element: 'SupplierAccountGroup'},
        distinctValues : true
        }]
         case
             when uuTien1.AccountGroup1 <> ''
                 then uuTien1.AccountGroup1
             when uuTien2.AccountGroup2 <> ''
                 then uuTien2.AccountGroup2
             when uuTien3.AccountGroup3 <> ''
                 then uuTien3.AccountGroup3
             else
                 uuTien4.AccountGroup4
         end                                                                        as AccountGroup,
         @EndUserText.label: 'Posting Period'
         je.FiscalPeriod,
         je.AccountingDocCreatedByUser   as UserName, //bc21
         taxAmount.DebitCreditCode,
         @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
         taxAmount.TaxBaseAmountInCoCodeCrcy,
//ThuyNM: edit 24/05/2024          
//         case 
//            when taxAmount.TaxCode like 'XB'
//                then cast('0' as abap.curr( 23, 2 ))
//            else taxAmount.TaxBaseAmountInCoCodeCrcy
//         end as TaxBaseAmountInCoCodeCrcy,
         @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
         taxAmount.TaxAmountInCoCodeCrcy as GTGT, //bc12
//         dienGiai.DienGiai         as MatHang,
         oadi.TaxType,
         taxCode.Value,
         taxCode.Taxgroup,
         taxCode.Rtype,
         taxAmount.TransactionCurrency,
         je._User.UserDescription,
         je.LastChangeDate,
         je.AccountingDocumentCreationDate,
         oadi.PurchasingDocument,
         @Search.defaultSearchElement: true
        @Consumption.valueHelpDefinition: [{ entity : { name: 'ZFI_GLACCOUNT_SH', element: 'GLAccount'},
        distinctValues : true
        }]
         oadi.GLAccount,
         case when oadi.FinancialAccountType <> 'K' and oadi.GLAccount not like '00133%'
            then oadi._ProfitCenter._Text.ProfitCenterName
         end as ProfitCenter,
         oadi.Supplier,
    concat_with_space( compadd.AddresseeName1,
    concat_with_space( compadd.AddresseeName2,
    concat_with_space( compadd.AddresseeName3,compadd.AddresseeName4 ,1),1),1)                as Company,   
    taxAmount.TransactionTypeDetermination,
    case
      when oadi.DocumentItemText <> ' '
        then oadi.DocumentItemText
      else
        je.AccountingDocumentHeaderText
    end as GhiChu
}
where
  (
        je.PostingDate                         >= $parameters.FromDate
    and je.PostingDate                         <= $parameters.ToDate
    and 
    taxAmount.TaxBaseAmountInTransCrcy     <> 0
    and taxAmount.TransactionTypeDetermination =  'VST'
    and je.IsReversed                          =  ''
    and je.IsReversed                          is initial
    and je.ReversalReason                      <> '01'
    //    and oadi.TaxType   = 'V'
  )
