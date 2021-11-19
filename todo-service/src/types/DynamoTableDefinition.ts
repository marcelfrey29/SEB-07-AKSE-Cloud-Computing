/**
 * This interface describes the required attributes of the DynamoDB Table.
 *
 * @property partitionKey {string} the partition key of the table
 * @property sortKey {string} the sort key of the table
 */
export interface DynamoTableDefinition {
    partitionKey: string;
    sortKey: string;
}
