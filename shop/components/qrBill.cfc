component
  displayname="QR-Bill"
  hint="QR-Bill"
  output=false
{


  /**
   * @hint This compionent implements the QR-Bill generator package from https://github.com/manuelbl/SwissQRBill/
   * @dependencies net.codecrete.qrbill:qrbill-generator
   * 
   * Documentation for the java library used in here can be found at: https://javadoc.io/doc/net.codecrete.qrbill/qrbill-generator/latest/index.html
   */
  public component function init() output=false {
    return this;
  }


  /**
   * @hint Create a new bill (net.codecrete.qrbill.generator.Bill)
   * https://javadoc.io/static/net.codecrete.qrbill/qrbill-generator/3.3.1/net/codecrete/qrbill/generator/Bill.html
   * 
   * @account  string   - the account number
   * @amount   numeric  - the amount
   * @currency string   - the currency
   */
  public Object function createBill(
    required string account,
    required numeric amount,
    required string currency,
    string billInformation = ""
  ) output=false {
    local.bill = createObject('java', 'net.codecrete.qrbill.generator.Bill');

    local.bill.setAccount(arguments.account);
    local.bill.setAmountFromDouble(arguments.amount);
    local.bill.setCurrency(arguments.currency);
    local.bill.setBillInformation(arguments.billInformation);

    return local.bill;
  }
  
  /**
   * @hint Create a new address (net.codecrete.qrbill.generator.Address)
   * https://javadoc.io/doc/net.codecrete.qrbill/qrbill-generator/latest/net/codecrete/qrbill/generator/Address.html
   */
  public Object function createAddress(
    required string name,
    required string street,
    required string houseNo,
    required string postalCode,
    required string town,
    required string countryCode
  ) output=false {
    local.address = createObject('java', 'net.codecrete.qrbill.generator.Address');

    local.address.setName(arguments.name);
    local.address.setStreet(arguments.street);
    local.address.setHouseNo(arguments.houseNo);
    local.address.setPostalCode(arguments.postalCode);
    local.address.setTown(arguments.town);
    local.address.setCountryCode(arguments.countryCode);

    return local.address;
  }


  /**
   * @hint defines the bill format
   * https://javadoc.io/doc/net.codecrete.qrbill/qrbill-generator/latest/net/codecrete/qrbill/generator/BillFormat.html
   * 
   * @graphicsFormat GraphicsFormat - the format of the bill
   * @Language Language - the language of the bill
   * @outputSize OutputSize - the output size of the bill, default: QR_BILL_ONLY
   * @seperatorType SeperatorType - the seperator between the qr code and the payment part, default: DASHED_LINE_WITH_SCISSORS
   * @localContryCode string - the local country code, default: CH
   * @marginLeft numeric - the margin left in mm, default: 5
   * @marginRight numeric - the margin right in mm, default: 5
   * @resolution numeric - the resolution in dpi, default: 144
   * @fontFamily string - the font family, default: Helvetica
   * 
   */
  public Object function createBillFormat(
    required Object graphicsFormat,
    required Object Language,
    Object outputSize = createOutputSize("QR_BILL_ONLY"),
    Object seperatorType = createSeperatorType("DASHED_LINE_WITH_SCISSORS"),
    string fontFamily = "Helvetica",
    string localContryCode = "CH",
    numeric marginLeft = 5,
    numeric marginRight = 5,
    numeric resolution = 144
  ) output=false {
    local.billFormat = createObject('java', 'net.codecrete.qrbill.generator.BillFormat');

    local.billFormat.setFontFamily(arguments.fontFamily);
    local.billFormat.setGraphicsFormat(arguments.graphicsFormat);
    local.billFormat.setLanguage(arguments.Language);
    local.billFormat.setLocalCountryCode(arguments.localContryCode);
    local.billFormat.setMarginLeft(arguments.marginLeft);
    local.billFormat.setOutputSize(arguments.outputSize);
    local.billFormat.setMarginRight(arguments.marginRight);
    local.billFormat.setResolution(arguments.resolution);
    local.billFormat.setSeparatorType(arguments.seperatorType);

    return local.billFormat;
  }


  /**
   * @hint Create a new QRBill (net.codecrete.qrbill.generator.QRBill)
   * https://javadoc.io/static/net.codecrete.qrbill/qrbill-generator/3.3.1/net/codecrete/qrbill/generator/QRBill.html
   */
  public Object function createQRBill() output=false {
    local.qrBill = createObject(type='java', classname='net.codecrete.qrbill.generator.QRBill');

    return local.qrBill;
  }


    /**
   * @hint defines file format for the bill
   * https://javadoc.io/static/net.codecrete.qrbill/qrbill-generator/3.3.1/net/codecrete/qrbill/generator/GraphicsFormat.html
   * 
   * @format string - the format of the bill (PNG, SVG, PDF)
   */
  public Object function createGraphicsFormat(
    required string format
  ) output=false {
    local.graphicsFormat = createObject('java', 'net.codecrete.qrbill.generator.GraphicsFormat');

    switch (arguments.format) {
      case 'PNG':
        local.graphicsFormat = local.graphicsFormat.PNG;
        break;
      case 'SVG':
        local.graphicsFormat = local.graphicsFormat.SVG;
        break;
      case 'PDF':
        local.graphicsFormat = local.graphicsFormat.PDF;
        break;
      default:
        local.graphicsFormat = null;
        break;
    }

    return local.graphicsFormat;
  }


  /**
   * @hint Create a new language (net.codecrete.qrbill.generator.Language)
   * https://javadoc.io/static/net.codecrete.qrbill/qrbill-generator/3.3.1/net/codecrete/qrbill/generator/Language.html
   * 
   * @language string - the language of the bill (DE, EN, FR, IT, RM)
   */
  public object function createLanguage(
    required string language
  ) output=false {
    local.language = createObject('java', 'net.codecrete.qrbill.generator.Language');

    switch (arguments.language) {
      case 'DE':
        local.language = local.language.DE;
        break;
      case 'EN':
        local.language = local.language.EN;
        break;
      case 'FR':
        local.language = local.language.FR;
        break;
      case 'IT':
        local.language = local.language.IT;
        break;
      case 'RM':
        local.language = local.language.RM;
        break;
      default:
        local.language = null;
        break;
    }

    return local.language;
  }


    /**
   * @hint Create a new output size (net.codecrete.qrbill.generator.OutputSize)
   * https://javadoc.io/doc/net.codecrete.qrbill/qrbill-generator/latest/net/codecrete/qrbill/generator/OutputSize.html
   * 
   * @outputSize string - the output size of the bill (A4_PORTRAIT_SHEET, PAYMENT_PART_ONLY, QR_BILL_EXTRA_SPACE, QR_BILL_ONLY, QR_CODE_ONLY, QR_CODE_WITH_QUIET_ZONE)
   */
  public Object function createOutputSize(
    required string outputSize
  ) output=false {
    local.outputSize = createObject('java', 'net.codecrete.qrbill.generator.OutputSize');

    switch (arguments.outputSize) {
      case 'A4_PORTRAIT_SHEET':
        local.outputSize = local.outputSize.A4_PORTRAIT_SHEET;
        break;
      case 'PAYMENT_PART_ONLY':
        local.outputSize = local.outputSize.PAYMENT_PART_ONLY;
        break;
      case 'QR_BILL_EXTRA_SPACE':
        local.outputSize = local.outputSize.QR_BILL_EXTRA_SPACE;
        break;
      case 'QR_BILL_ONLY':
        local.outputSize = local.outputSize.QR_BILL_ONLY;
        break;
      case 'QR_CODE_ONLY':
        local.outputSize = local.outputSize.QR_CODE_ONLY;
        break;
      case 'QR_CODE_WITH_QUIET_ZONE':
        local.outputSize = local.outputSize.QR_CODE_WITH_QUIET_ZONE;
        break;
      default:
        local.outputSize = null;
        break;
    }

    return local.outputSize;
  }


  /**
   * @hint defines the seperator between the qr code and the payment part
   * https://javadoc.io/static/net.codecrete.qrbill/qrbill-generator/3.3.1/net/codecrete/qrbill/generator/SeparatorType.html
   */
  public Object function createSeperatorType(
    required string seperatorType
  ) output=false {
    local.seperator = createObject('java', 'net.codecrete.qrbill.generator.SeparatorType');

    switch (arguments.seperatorType) {
      case 'DASHED_LINE':
        local.seperator = local.seperator.DASHED_LINE;
        break;
      case 'DASHED_LINE_WITH_SCISSORS':
        local.seperator = local.seperator.DASHED_LINE_WITH_SCISSORS;
        break;
      case 'DOTTED_LINE':
        local.seperator = local.seperator.DOTTED_LINE;
        break;
      case 'DOTTED_LINE_WITH_SCISSORS':
        local.seperator = local.seperator.DOTTED_LINE_WITH_SCISSORS;
        break;
      case 'SOLID_LINE':
        local.seperator = local.seperator.SOLID_LINE;
        break;
      case 'SOLID_LINE_WITH_SCISSORS':
        local.seperator = local.seperator.SOLID_LINE_WITH_SCISSORS;
        break;
      default:
        local.seperator = local.seperator.NONE;
        break;
    }

    return local.seperator;
  }
}