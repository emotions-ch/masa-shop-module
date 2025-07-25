component
  accessors="false"
  displayname="Billing"
  hint="Billing"
  output="false"
{


  /**
   * @hint Initialize component
   */
  public component function init() output=false {
    return this;
  }

  /**
   * @hint 
   */
  public string function generateBillingTable(
    required component cart,
    numeric shippingCost=0
  ) output=true {
    savecontent variable="local.billingTable" {
      writeOutput('
        <table class="table table-bordered table-sm">
          <thead>
            <tr>
              <th scope="col">Produktname</th>
              <th scope="col">Modell</th>
              <th scope="col">Variante</th>
              <th scope="col">Menge</th>
              <th scope="col">Einzelpreis</th>
              <th scope="col">Summe</th>
            </tr>
          </thead>
          <tbody>
      ');

      for(local.article in arguments.cart.getArticles()) {
        writeOutput("
            <tr>
              <td>#local.article.getTitle()#</td>
              <td>#local.article.getArticleNumber()#</td>
              <td>#application.serviceFactory.getBean('m').getBean('category').loadBy(categoryid=local.article.getVariant()).getName()#</td>
              <td>#local.article.getQuantity()#</td>
              <td>CHF #decimalFormat(local.article.getPrice())#</td>
              <td>CHF #decimalFormat(local.article.getPrice()*local.article.getQuantity())#</td>
            </tr>
        ");
      };

      writeOutput('
            <tr>
              <td colspan="4" class="text-right">Zwischensumme:</td>
              <td>CHF #decimalFormat(arguments.cart.getTotalPrice())#</td>
            </tr>
            <tr>
              <td colspan="4" class="text-right">B-Post Economy, Schweiz:</td>
              <td>CHF #decimalFormat(arguments.shippingCost)#</td>
            </tr>
            <tr>
              <td colspan="4" class="text-right"><b>Summe:</b></td>
              <td><b>CHF #decimalFormat(arguments.cart.getTotalPrice(arguments.shippingCost))#</b></td>
            </tr>
          </tbody>
        </table>
      ');
    }

    return local.billingTable;
  }

  /**
   * @hint 
   * 
   * the argument creditor has to be made with qrBill.createAddress()
   */
  public any function getQrInvoice(
    required component cart,
    required string iban,
    required object creditor,
    string unstructuredMessage = "",
    numeric shippingCost=0
  ) output=false {
    local.main = new qrBill();

    local.bill = local.main.createBill(
      arguments.iban,
      #arguments.cart.getTotalPrice(arguments.shippingCost)#,
      "CHF"
    );

    local.bill.setCreditor(arguments.creditor);
    
    local.bill.createAndSetQRReference(second(now()));
    local.bill.setUnstructuredMessage(arguments.unstructuredMessage);

    local.bill.setFormat(
      local.main.createBillFormat(
        language=local.main.createLanguage("de"),
        graphicsFormat=local.main.createGraphicsFormat("PNG"),
        seperatorType=local.main.createSeperatorType('SOLID_LINE')
      )
    );
    local.qrbill = local.main.createQRBill().generate(local.bill);

    return local.qrbill;
  }
}