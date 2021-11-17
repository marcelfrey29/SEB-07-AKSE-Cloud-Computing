import { Injectable, Logger } from '@nestjs/common';
import { v4 as uuidv4 } from 'uuid';
import { DynamodbService } from '../dynamodb/dynamodb.service';
import { TodoList } from '../types/TodoList.interface';

@Injectable()
export class ListService {
    private readonly logger = new Logger(ListService.name);

    constructor(private dynamodbService: DynamodbService) {}

    getLists(user: User): TodoList[] {
        this.logger.log('');
        this.dynamodbService.getLists(user.sid);
        return [];
    }

    createList(user: User, listInfo: Partial<TodoList>) {
        console.log(uuidv4());
        return undefined;
    }
}
