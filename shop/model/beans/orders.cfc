component
  displayName="Order Bean"
  entityName="shopOrder"
  hint="This provides the Order Table"
  table="tshopOrders"
  output="false"
  persistent="true"
{
  // primary key
  property name="orderId" setter="false" getter="true" type="string" ormType="string" length="35" fieldtype="id" unique="true" nullable="false" required="true" generator="uuid";

  // fields
  property name="productContentIds" setter="true" getter="true" type="string" ormType="text" nullable="false" required="true"; //json object of contentIds & quantities
  property name="orderDate" setter="true" getter="true" type="datetime" ormType="datetime" nullable="false" required="true";
  property name="billingId" setter="true" getter="true" type="string" ormType="string" nullable="false" required="true"; //session.SessionID of the order

  // relationships
  property name="customerId" setter="true" getter="true" fieldType="many-to-one" cfc="customers" fkColumn="customerId" lazy="false";
  // property name="payments" setter="true" getter="true" fieldType="one-to-one" cfc="payments" fkColumn="paymentId" singularName="payment" lazy="true" nullValue="true" required="false"; 
  property name="adressId" setter="true" getter="true" fieldType="many-to-one" cfc="adresses" fkColumn="adressId" lazy="false";
  property name="shippingAddressId" setter="true" getter="true" fieldType="many-to-one" cfc="adresses" fkColumn="shippingAdressId" lazy="false" nullable="true" required="false";
}