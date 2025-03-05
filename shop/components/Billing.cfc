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
   */
  public any function getQrInvoice(
    required component cart,
    string unstructuredMessage = "",
    numeric shippingCost=0
  ) output=false {
    local.main = new qrBill();
    // the data in here is just a stub for testing purposes

    local.bill = local.main.createBill(
      "CH8230787786229140905",
      #arguments.cart.getTotalPrice(arguments.shippingCost)#,
      "CHF"
    );

    local.bill.setCreditor(
        local.main.createAddress(
          name="Hundeschule FAMCANE GmbH",
          street="Dorfstrasse",
          houseNo="34",
          postalCode="6340",
          town="Baar",
          countryCode="CH"
        )
      );
    
    local.bill.setReference("210000000003139471430009017");
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