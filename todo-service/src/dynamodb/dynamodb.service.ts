import { Injectable, Logger } from '@nestjs/common';
import {
    DeleteItemCommand,
    DynamoDBClient,
    PutItemCommand,
    QueryCommand,
    UpdateItemCommand,
} from '@aws-sdk/client-dynamodb';
import { ConfigService } from '@nestjs/config';
import { TodoList } from '../types/TodoList.interface';
import { marshall, unmarshall } from '@aws-sdk/util-dynamodb';
import { TodoElement } from '../types/Todo.interface';

/**
 * The DynamoDbService is responsible for storing and retrieving data.
 */
@Injectable()
export class DynamodbService {
    private readonly logger = new Logger(DynamodbService.name);
    private readonly dynamoDBClient: DynamoDBClient;
    private readonly TABLE_NAME: string;

    constructor(private configService: ConfigService) {
        this.logger.log('Setting up DynamoDB...');
        this.dynamoDBClient = new DynamoDBClient({
            region: this.configService.get<string>('DYNAMODB_REGION'),
            endpoint: this.configService.get<string>('DYNAMODB_ENDPOINT'),
        });
        this.TABLE_NAME =
            this.configService.get<string>('DYNAMODB_TABLE_NAME') ?? 'Todos';
    }

    /**
     * Return all lists from the database.
     *
     * @param partitionQuery {string} the partition-key (user id) to query for
     * @return {TodoList[]} the lists of the user
     */
    async getListsOfUser(partitionQuery: string): Promise<TodoList[]> {
        this.logger.log('Querying all lists for the user ' + partitionQuery);

        const queryListsCommand = new QueryCommand({
            KeyConditionExpression: '#partitionKey = :partitionKey',
            ExpressionAttributeNames: {
                '#partitionKey': 'partitionKey',
            },
            ExpressionAttributeValues: marshall({
                ':partitionKey': partitionQuery,
            }),
            TableName: this.TABLE_NAME,
            ReturnConsumedCapacity: 'TOTAL',
        });

        const lists: TodoList[] = [];
        try {
            const dynamoListData = await this.dynamoDBClient.send(
                queryListsCommand,
            );
            this.logger.log(
                'Successfully loaded lists. (RequestID: ' +
                    dynamoListData.$metadata.requestId +
                    ', capacity_units:' +
                    dynamoListData.ConsumedCapacity.CapacityUnits +
                    ')',
            );

            dynamoListData.Items.forEach((item) => {
                const listItem = unmarshall(item) as TodoList;
                lists.push(listItem);
            });
        } catch (error) {
            this.logger.warn(
                'Error while loading lists from DynamoDB: ' + error,
            );
        }

        return lists;
    }

    /**
     * Add a new List entry to the database.
     *
     * @param list {TodoList} the list object to save
     * @return {void}
     */
    async createList(list: TodoList): Promise<void> {
        this.logger.log(
            'Save' + list.partitionKey + ' | ' + list.sortKey + ' to DynamoDB.',
        );

        const putListCommand = new PutItemCommand({
            Item: marshall(list),
            TableName: this.TABLE_NAME,
            ReturnConsumedCapacity: 'TOTAL',
        });

        try {
            const insertedData = await this.dynamoDBClient.send(putListCommand);
            this.logger.log(
                'Saved list to DynamoDB. (RequestID: ' +
                    insertedData.$metadata.requestId +
                    ', capacity_units:' +
                    insertedData.ConsumedCapacity.CapacityUnits +
                    ')',
            );
        } catch (error) {
            this.logger.warn('Error while saving list to DynamoDB: ' + error);
        }
    }

    /**
     * Returns all tasks of a list from the database.
     *
     * @param partitionQuery {string} the partition-key (list id) to query for
     * @return {TodoElement[]} the task in the given list
     */
    async getTodosOfList(partitionQuery: string): Promise<TodoElement[]> {
        this.logger.log('Querying all tasks in the list' + partitionQuery);

        const queryListsCommand = new QueryCommand({
            KeyConditionExpression: '#partitionKey = :partitionKey',
            ExpressionAttributeNames: {
                '#partitionKey': 'partitionKey',
            },
            ExpressionAttributeValues: marshall({
                ':partitionKey': partitionQuery,
            }),
            TableName: this.TABLE_NAME,
            ReturnConsumedCapacity: 'TOTAL',
        });

        const lists: TodoElement[] = [];
        try {
            const dynamoTodoElementData = await this.dynamoDBClient.send(
                queryListsCommand,
            );
            this.logger.log(
                'Successfully loaded lists. (RequestID: ' +
                    dynamoTodoElementData.$metadata.requestId +
                    ', capacity_units:' +
                    dynamoTodoElementData.ConsumedCapacity.CapacityUnits +
                    ')',
            );

            dynamoTodoElementData.Items.forEach((item) => {
                const listItem = unmarshall(item) as TodoElement;
                lists.push(listItem);
            });
        } catch (error) {
            this.logger.warn(
                'Error while loading lists from DynamoDB: ' + error,
            );
        }

        return lists;
    }

    /**
     * Save a new task to the database.
     *
     * @param todoElement {TodoElement} the task to save
     * @return {void}
     */
    async createTodoElementInList(todoElement: TodoElement): Promise<void> {
        this.logger.log(
            'Save' +
                todoElement.partitionKey +
                ' | ' +
                todoElement.sortKey +
                ' to DynamoDB.',
        );

        const putListCommand = new PutItemCommand({
            Item: marshall(todoElement),
            TableName: this.TABLE_NAME,
            ReturnConsumedCapacity: 'TOTAL',
        });

        try {
            const insertedData = await this.dynamoDBClient.send(putListCommand);
            this.logger.log(
                'Saved task to DynamoDB. (RequestID: ' +
                    insertedData.$metadata.requestId +
                    ', capacity_units:' +
                    insertedData.ConsumedCapacity.CapacityUnits +
                    ')',
            );
        } catch (error) {
            this.logger.warn('Error while saving task to DynamoDB: ' + error);
        }
    }

    /**
     * Update an existing task.
     *
     * @param todoElement {TodoElement} the element to update
     * @return {void}
     */
    async updateTodoElement(todoElement: TodoElement): Promise<void> {
        this.logger.log(
            'Update todo' +
                todoElement.sortKey +
                ' of list ' +
                todoElement.partitionKey +
                ' in DynamoDB.',
        );

        const updateTodoCommand = new UpdateItemCommand({
            Key: marshall({
                partitionKey: todoElement.partitionKey,
                sortKey: todoElement.sortKey,
            }),
            UpdateExpression:
                'set title = :title, description = :description, dueDate = :dueDate, isFlagged = :isFlagged, tags = :tags, isDone = :isDone',
            ExpressionAttributeValues: marshall({
                ':title': todoElement.title,
                ':description': todoElement.description,
                ':dueDate': todoElement.dueDate,
                ':isFlagged': todoElement.isFlagged,
                ':tags': todoElement.tags,
                ':isDone': todoElement.isDone,
            }),
            TableName: this.TABLE_NAME,
            ReturnConsumedCapacity: 'TOTAL',
        });

        try {
            const insertedData = await this.dynamoDBClient.send(
                updateTodoCommand,
            );
            this.logger.log(
                'Updated task in DynamoDB. (RequestID: ' +
                    insertedData.$metadata.requestId +
                    ', capacity_units: ' +
                    insertedData.ConsumedCapacity.CapacityUnits +
                    ')',
            );
        } catch (error) {
            this.logger.warn('Error while updating task in DynamoDB: ' + error);
        }
    }

    /**
     * Delete a task from a list.
     *
     * @param todoElement {Partial<TodoElement>} the element to delete
     * @return {void}
     */
    async deleteTodoElement(todoElement: Partial<TodoElement>): Promise<void> {
        this.logger.log(
            'Delete todo' +
                todoElement.sortKey +
                ' from list ' +
                todoElement.partitionKey +
                ' in DynamoDB.',
        );

        const deleteTodoCommand = new DeleteItemCommand({
            Key: marshall({
                partitionKey: todoElement.partitionKey,
                sortKey: todoElement.sortKey,
            }),
            ConditionExpression:
                'partitionKey = :partitionKey AND sortKey = :sortKey',
            ExpressionAttributeValues: marshall({
                ':partitionKey': todoElement.partitionKey,
                ':sortKey': todoElement.sortKey,
            }),
            TableName: this.TABLE_NAME,
            ReturnConsumedCapacity: 'TOTAL',
        });

        try {
            const insertedData = await this.dynamoDBClient.send(
                deleteTodoCommand,
            );
            this.logger.log(
                'Deleted task from DynamoDB. (RequestID: ' +
                    insertedData.$metadata.requestId +
                    ', capacity_units: ' +
                    insertedData.ConsumedCapacity.CapacityUnits +
                    ')',
            );
        } catch (error) {
            this.logger.warn('Error while deleting task in DynamoDB: ' + error);
        }
    }

    /**
     * Return a task in a list.
     *
     * @param partitionKey {string} the unique id of the list
     * @param sortKey {string} the unique id of the todo
     * @return {TodoElement} returns the task with the given id
     */
    async getTodoById(
        partitionKey: string,
        sortKey: string,
    ): Promise<TodoElement> {
        this.logger.log('Load todo ' + sortKey + ' of list ' + partitionKey);

        const queryTodoCommand = new QueryCommand({
            KeyConditionExpression:
                '#partitionKey = :partitionKey AND #sortKey = :sortKey',
            ExpressionAttributeNames: {
                '#partitionKey': 'partitionKey',
                '#sortKey': 'sortKey',
            },
            ExpressionAttributeValues: marshall({
                ':partitionKey': partitionKey,
                ':sortKey': sortKey,
            }),
            TableName: this.TABLE_NAME,
            ReturnConsumedCapacity: 'TOTAL',
        });

        try {
            const dynamoTodoData = await this.dynamoDBClient.send(
                queryTodoCommand,
            );
            this.logger.log(
                'Successfully loaded todo. (RequestID: ' +
                    dynamoTodoData.$metadata.requestId +
                    ', capacity_units: ' +
                    dynamoTodoData.ConsumedCapacity.CapacityUnits +
                    ')',
            );

            if (dynamoTodoData.Items.length > 1) {
                this.logger.error(
                    'Queried for exact one todo, but received more than one!',
                );
            }

            return unmarshall(dynamoTodoData.Items[0]) as TodoElement;
        } catch (error) {
            this.logger.warn(
                'Error while loading lists from DynamoDB: ' + error,
            );
        }
        throw new Error('Query error or too many todos.');
    }
}
