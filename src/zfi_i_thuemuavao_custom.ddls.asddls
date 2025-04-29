@EndUserText.label: 'Bảng kê thuế mua vào custom'
@ObjectModel.query.implementedBy: 'ABAP:ZFI_CL_BANGTHUEMUAVAO_CUSTOM'
define custom entity ZFI_I_THUEMUAVAO_CUSTOM
  with parameters
    @Environment.systemField:#SYSTEM_DATE
    @EndUserText.label: 'From Date'
    FromDate : vdm_v_key_date,
    @Environment.systemField:#SYSTEM_DATE
    @EndUserText.label: 'To Date'
    ToDate   : vdm_v_key_date
{
      @UI                       : {
      selectionField            : [{ position: 40 }],
      lineItem                  : [{ position: 100 , importance: #MEDIUM }]}
      @EndUserText.label        : 'Company Code'
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity : { name: 'I_CompanyCodeStdVH', element: 'CompanyCode'},
    distinctValues              : true
    }]
  key CompanyCode               : bukrs;
      @UI                       : {
      selectionField            : [{ position: 30 }],
      lineItem                  : [{ position: 200 , importance: #MEDIUM } ]}
      @Consumption.filter       : { mandatory: true}
      @EndUserText.label        : 'FiscalYear'
  key FiscalYear                : gjahr;
      @ObjectModel.text.element : [ 'AccountingDocument' ]
      @UI                       : {
      selectionField            : [{ position: 50 }],
      lineItem                  : [{ position: 160 , importance: #MEDIUM } ]}
      @EndUserText.label        : 'AccountingDocument'
  key AccountingDocument        : belnr_d;
      @UI.hidden                : true
  key AccountingDocumentItem    : buzei;
      @UI.hidden                : true
  key TaxCode                   : mwskz;
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity : { name: 'ZFI_GLACCOUNT_SH', element: 'GLAccount'},
      distinctValues            : true
      }]
      GLAccount                 : hkont;
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity : { name: 'ZFI_ACCOUNTGROUP_SUP_SH', element: 'SupplierAccountGroup'},
    distinctValues              : true
    }]
      AccountGroup              : ktokk;
      DocumentReferenceID       : xblnr;
      NgayPhatHanh              : bldat;
      PostingDate               : budat;
      TenNguoiBan               : abap.char( 255 );
      MSTNguoiBan               : stcd1;
      DienGiai                  : abap.char( 255 );
      DVT                       : meins;
      @Semantics.quantity.unitOfMeasure: 'DVT'
      SoLuong                   : abap.dec(12,2);
      DVT_E                     : mseh3;
      DebitCreditCode           : shkzg;
      CompanyCodeCurrency       : zde_currh;
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      TaxBaseAmountInCoCodeCrcy : zde_wertv12;
      Value                     : abap.char(10);
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      GTGT                      : zde_wertv12;
      GhiChu                    : abap.char( 255 );
      Diachi                    : abap.char( 255 );
      UserName                  : usnam;
      Taxgroup                  : abap.char(10);
      Rtype                     : abap.char(5);
      Company                   : abap.char( 255 );

}
