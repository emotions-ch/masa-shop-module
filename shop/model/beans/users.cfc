component
  displayName="User Bean"
  entityName="user"
  hint="This provides the User Table"
  table="tusers"
  output="false"
  persistent="true"
{
  // primary key
  property name="userId" setter="false" getter="true" type="string" ormType="string" length="35" fieldtype="id" unique="true" nullable="false" required="true" generator="uuid";

  // fields
  property name="username" setter="true" getter="true" type="string" ormType="string" length="50" nullable="true" required="false";
  property name="password" setter="true" getter="true" type="string" ormType="string" length="100" nullable="true" required="false";
  property name="passwordCreated" setter="true" getter="true" type="datetime" ormType="datetime" nullable="true" required="false";
  property name="firstname" setter="true" getter="true" type="string" ormType="string" length="50" nullable="true" required="false";
  property name="lastname" setter="true" getter="true" type="string" ormType="string" length="50" nullable="true" required="false";
  property name="email" setter="true" getter="true" type="string" ormType="string" length="100" nullable="true" required="false";
  property name="inActive" setter="true" getter="true" type="boolean" ormType="bit" nullable="false" required="true" default="0";
  property name="created" setter="true" getter="true" type="datetime" ormType="datetime" nullable="false" required="true";
  property name="lastLogin" setter="true" getter="true" type="datetime" ormType="datetime" nullable="true" required="false";
  property name="lastUpdate" setter="true" getter="true" type="datetime" ormType="datetime" nullable="true" required="false";

  // relationships
  property name="orders" fieldType="one-to-many" cfc="orders" fkColumn="userId" singularName="order" lazy="true";
}