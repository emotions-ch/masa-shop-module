component
  displayName="Customer Bean"
  entityName="customer"
  hint="This provides the Customer Table"
  table="tshopCustomers"
  output="false"
  persistent="true"
{
  // primary key
  property name="customerId" setter="false" getter="true" type="string" ormType="string" length="35" fieldtype="id" unique="true" nullable="false" required="true" generator="uuid";

  // fields
  property name="customername" setter="true" getter="true" type="string" ormType="string" length="50" nullable="true" required="false";
  property name="password" setter="true" getter="true" type="string" ormType="string" length="100" nullable="true" required="false";
  property name="passwordCreated" setter="true" getter="true" type="datetime" ormType="datetime" nullable="true" required="false";
  property name="firstname" setter="true" getter="true" type="string" ormType="string" length="50" nullable="true" required="false";
  property name="lastname" setter="true" getter="true" type="string" ormType="string" length="50" nullable="true" required="false";
  property name="email" setter="true" getter="true" type="string" ormType="string" length="100" nullable="true" required="false";
  property name="active" setter="true" getter="true" type="boolean" ormType="bit" nullable="false" required="true" default="1";
  property name="created" setter="true" getter="true" type="datetime" ormType="datetime" nullable="false" required="true";
  property name="lastLogin" setter="true" getter="true" type="datetime" ormType="datetime" nullable="true" required="false";
  property name="lastUpdate" setter="true" getter="true" type="datetime" ormType="datetime" nullable="true" required="false";

  // relationships
  property name="orders" fieldType="one-to-many" cfc="orders" fkColumn="customerId" singularName="order" lazy="true";
}