/**
 * This interface describes the required attributes of the DynamoDB Table.
 *
 * @property partition {string} the partition key of the table
 * @property sort {string} the sort key of the table
 */
export interface DynamoTableDefinition {
    partition: string;
    sort: string;
}
