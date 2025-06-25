component
  accessors="false"
  hint="handles server-side checkout logic"
  output="true"
{
  public component function init() {
    return this;
  }

  /**
   * @hint stores the order in the database
   * @param orderForm the form data submitted by the user
   * @param session the current session data
   * @return void
   */
  public void function storeOrder(
    required struct orderForm,
    required struct session
  ) {
    if (structKeyExists(arguments.session, "customer") AND arguments.session.customer.getEmail() EQ arguments.orderForm.email) {
      local.customer = arguments.session.customer;
      // writeDump("loaded existing customer from arguments.session");
    } else {
      local.customer = entityNew("customer",
        {
          firstname: arguments.orderForm.firstname,
          lastname: arguments.orderForm.lastname,
          email: arguments.orderForm.email,
          password: nullValue(),
          active: 0,
          created: now(),
          lastLogin: now(),
          lastUpdate: now()
        }
      );
      entitySave(local.customer, true);
      ormFlush();
      local.customerId = entityLoad("customer", {email=arguments.orderForm.email})[1].getCustomerId();
    }

    local.address = entityNew("shopAddress",
      {
        firstname: arguments.orderForm.firstname,
        lastname: arguments.orderForm.lastname,
        street: arguments.orderForm.address,
        zip: arguments.orderForm.zip,
        city: arguments.orderForm.city
      }
    );

    local.addressExists = entityLoadByExample(local.address, true);
    if (structKeyExists(local, "addressExists")) {
      local.address = local.addressExists;
      writeDump("loaded existing address");
    } else {
      local.address.setCreated(now());
      entitySave(local.address, true);
      ormFlush();
    }

    local.order = entityNew("shopOrder",
      {
        productContentIds: arguments.session.cart.getCartJson(),
        orderDate: now(),
        billingId: arguments.session.SessionID,
        customerId: local.customer,
        adressId: local.address
      }
    );

    if (structKeyExists(arguments.orderForm, "alternateShippingAddress") && arguments.orderForm.alternateShippingAddress == "on") {
      local.shippingAddress = entityNew("shopAddress",
        {
          firstname: arguments.orderForm.shippingFirstname,
          lastname: arguments.orderForm.shippingLastname,
          street: arguments.orderForm.shippingAddress,
          zip: arguments.orderForm.shippingZip,
          city: arguments.orderForm.shippingCity
        }
      );

      local.shippingAddressExists = entityLoadByExample(local.shippingAddress, true);
      if (structKeyExists(local, "shippingAddressExists")) {
        local.shippingAddress = local.shippingAddressExists;
        // writeDump("loaded existing Shippingaddress");
      } else {
        local.shippingAddress.setCreated(now());
        entitySave(local.shippingAddress, true);
        ormFlush();
      }

      local.order.setshippingAddressId(local.shippingAddress);
    }
    // writeDump(var=local.order, abort=false);
    entitySave(local.order, true);
    ormFlush();
  }

  /**
   * returns the stored user details for the checkout form 
   */
  public struct function retriveCustomerData(
    required struct session
  ) {
    local.storedCustomerData = {
      email = "",
      firstname = "",
      lastname = "",
      billingAddress = {
        street = "",
        zip = "",
        city = ""
      },
      shippingAddress = {
        active = "",
        firstname = "",
        lastname = "",
        street = "",
        zip = "",
        city = ""
      }
    };

    if ( structKeyExists(arguments.session, "customer") ) {
      //  the empty string gets appended beacause the default value of the values is NULL, which means I cannot instert them into a form 
      local.storedCustomerData.email = arguments.session.customer.getEmail() & "";
      local.storedCustomerData.firstname = arguments.session.customer.getFirstname() & "";
      local.storedCustomerData.lastname = arguments.session.customer.getLastname() & "";
      local.ordersArray = arguments.session.customer.getOrders();

      if ( !isNull(local.ordersArray) && isArray(local.ordersArray) && arrayLen(local.ordersArray) > 0 ) {
        local.lastOrder = local.ordersArray.last();
        local.latestBillingAddressObject =  local.lastOrder.getAdressId();

        if ( !isNull(local.latestBillingAddressObject) ) {
          local.storedCustomerData.billingAddress.street = local.latestBillingAddressObject.getStreet() & "";
          local.storedCustomerData.billingAddress.zip = local.latestBillingAddressObject.getZip() & "";
          local.storedCustomerData.billingAddress.city = local.latestBillingAddressObject.getCity() & "";
        }

        local.latestShippingAddressObject =  local.lastOrder.getShippingAddressId();
        if ( !isNull(local.latestShippingAddressObject) ) {
          local.storedCustomerData.shippingAddress.active = "checked";
          local.storedCustomerData.shippingAddress.firstname = local.latestShippingAddressObject.getFirstname() & "";
          local.storedCustomerData.shippingAddress.lastname = local.latestShippingAddressObject.getLastname() & "";
          local.storedCustomerData.shippingAddress.street = local.latestShippingAddressObject.getStreet() & "";
          local.storedCustomerData.shippingAddress.zip = local.latestShippingAddressObject.getZip() & "";
          local.storedCustomerData.shippingAddress.city = local.latestShippingAddressObject.getCity() & "";
        }
      }
    }

    return local.storedCustomerData;
  }
}