# Todo-DB Data Modeling (NoSQL, DynamoDB)

## Entity-Relationship Diagram

> The **User** Entity is managed by Keycloak.<br>
> We only need the UserID which can be read from the JWT.

- A **User** can have multiple **Lists**
- A **List** can have multiple **Todo**-Item

![ERM Diagram](ERM-Diagram.jpg)

## Access Patterns

> The UserID is known from the JWT. <br>
> We don't need to store Users.

Entity | Access Pattern            | Query
------ | ------------------------- | -----
List   | Fetch all lists of a user | `PK = "USER#<userID>"`
List   | Fetch one list            | `PK = "USER#<userID>"` <br>`SK = "LIST#<listID>"`
List   | Update an existing list   | `PK = "USER#<userID>"` <br>`SK = "LIST#<listID>"`
List   | Delete an existing list   | `PK = "USER#<userID>"` <br>`SK = "LIST#<listID>"`
Todo   | Fetch all todos of a list | `PK = "LIST#<listID>"`
Todo   | Fetch one todo            | `PK = "LIST#<listID"` <br>`SK = "TODO#<todoID>"`
Todo   | Update an existing todo   | `PK = "LIST#<listID"` <br>`SK = "TODO#<todoID>"`
Todo   | Delete an existing todo   | `PK = "LIST#<listID"` <br>`SK = "TODO#<todoID>"`

## Entity Table (Item Types)

> No User, because we don't have to store them in this table.

Entity | Partition Key   | Sort Key        | Attributes
------ | --------------- | --------------- | ----------
List   | `USER#<userID>` | `LIST#<listID>` | <br>`partitionKey` (UserID)<br>`sortKey` (ListID)<br>`name`<br>`color`<br>`icon`
Todo   | `LIST#<listID>` | `TODO#<todoID>` | <br>`partitionKey` (ListID)<br>`sortKey` (TodoID)<br>`title`<br>`description`<br>`dueDate`<br>`isFlagged`<br>`tags`<br>`isDone`<br>`owner` (UserID)

## Table Structure (Example)

![Example of the Table Structure](Structure-Example.jpg)
