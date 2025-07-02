component
  displayName="Payment Bean"
  entityName="payment"
  hint="This provides the Payment Table"
  table="tshopPayments"
  output="false"
  persistent="true"
{
  // primary key
  property name="paymentId" setter="false" getter="true" type="string" ormType="string" length="35" fieldtype="id" unique="true" nullable="false" required="true" generator="uuid";

  // fields
  property name="transactionDate" setter="true" getter="true" type="datetime" ormType="datetime" nullable="true" required="false";
  property name="transactionId" setter="true" getter="true" type="string" ormType="string" length="50" nullable="true" required="false";

  // relationships
  property name="orderId" fieldType="one-to-one" cfc="orders" fkColumn="userId" lazy="true";
}