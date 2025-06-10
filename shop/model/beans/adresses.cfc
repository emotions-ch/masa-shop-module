component
  displayName="Address Bean"
  entityName="shopAddress"
  hint="This provides the Address Table"
  table="tshopAddresses"
  output="false"
  persistent="true"
{
  // primary key
  property name="addressId" setter="false" getter="true" type="string" ormType="string" length="35" fieldtype="id" unique="true" nullable="false" required="true" generator="uuid";

  // fields
  property name="firstname" setter="true" getter="true" type="string" ormType="string" length="50" nullable="true" required="false";
  property name="lastname" setter="true" getter="true" type="string" ormType="string" length="50" nullable="true" required="false";
  property name="street" setter="true" getter="true" type="string" ormType="string" length="50" nullable="false" required="true";
  property name="zip" setter="true" getter="true" type="string" ormType="string" length="50" nullable="false" required="true";
  property name="city" setter="true" getter="true" type="string" ormType="string" length="50" nullable="false" required="true";
  property name="created" setter="true" getter="true" type="datetime" ormType="datetime" nullable="true" required="false";

  // relationships
  property name="customerId" fieldType="many-to-one" cfc="customers" fkColumn="customerId" lazy="true";
  property name="orderId" fieldType="many-to-many" linktable="addressOrder" cfc="orders" fkColumn="orderId" lazy="true";
}