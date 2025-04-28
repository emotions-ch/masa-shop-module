component
  displayName="Order Bean"
  entityName="order"
  hint="This provides the Order Table"
  table="torders"
  output="false"
  persistent="true"
{
  // primary key
  property name="orderId" setter="false" getter="true" type="string" ormType="string" length="35" fieldtype="id" unique="true" nullable="false" required="true" generator="uuid";

  // fields
  property name="productContentIds" setter="true" getter="true" type="string" ormType="text" nullable="false" required="true"; //json array of contentIds

  // relationships
  property name="customerId" fieldType="many-to-one" cfc="customers" fkColumn="userId" lazy="true";
  property name="payments" fieldType="one-to-one" cfc="payments" fkColumn="orderId" singularName="payment" lazy="true";

}