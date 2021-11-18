import { Injectable, Logger } from '@nestjs/common';
import {
    DynamoDBClient,
    PutItemCommand,
    QueryCommand,
} from '@aws-sdk/client-dynamodb';
import { ConfigService } from '@nestjs/config';
import { TodoList } from '../types/TodoList.interface';
import { marshall, unmarshall } from '@aws-sdk/util-dynamodb';

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
     * @param partitionQuery {string} the partition key to query for
     * @return {TodoList[]} the lists of the user
     */
    async getListsOfUser(partitionQuery: string): Promise<TodoList[]> {
        this.logger.log('Querying all lists for ' + partitionQuery);

        const queryListsCommand = new QueryCommand({
            KeyConditionExpression: '#partition = :partition',
            ExpressionAttributeNames: {
                '#partition': 'partition',
            },
            ExpressionAttributeValues: marshall({
                ':partition': partitionQuery,
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
     */
    async createList(list: TodoList): Promise<void> {
        this.logger.log(
            'Save' + list.partition + ' | ' + list.sort + ' to DynamoDB.',
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
     * @param partitionQuery {string} the partition key (list id) to query for
     * @return {TodoElement[]} the task in the given list
     */
    async getTodosOfList(partitionQuery: string): Promise<TodoElement[]> {
        this.logger.log('Querying all taks in the list' + partitionQuery);

        const queryListsCommand = new QueryCommand({
            KeyConditionExpression: '#partition = :partition',
            ExpressionAttributeNames: {
                '#partition': 'partition',
            },
            ExpressionAttributeValues: marshall({
                ':partition': partitionQuery,
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
                todoElement.partition +
                ' | ' +
                todoElement.sort +
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
}
