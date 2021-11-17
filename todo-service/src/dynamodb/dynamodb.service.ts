import { Injectable, Logger } from '@nestjs/common';
import { DynamoDBClient } from '@aws-sdk/client-dynamodb';
import { ConfigService } from '@nestjs/config';

/**
 * The DynamoDbService is responsible for storing and retrieving data.
 */
@Injectable()
export class DynamodbService {
    private readonly logger = new Logger(DynamodbService.name);
    private readonly dynamoDBClient: DynamoDBClient;

    constructor(private configService: ConfigService) {
        this.logger.log('Setting up DynamoDB...');
        this.dynamoDBClient = new DynamoDBClient({
            region: this.configService.get<string>('DYNAMODB_REGION'),
            endpoint: this.configService.get<string>('DYNAMODB_ENDPOINT'),
        });
    }

    getLists(sid: string) {
        console.log('Get List');
    }
}
