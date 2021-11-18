import { Injectable, Logger } from '@nestjs/common';
import { v4 as uuidv4 } from 'uuid';
import { DynamodbService } from '../dynamodb/dynamodb.service';
import { TodoList } from '../types/TodoList.interface';
import {
    LIST_PARTITION_PREFIX,
    USER_PARTITION_PREFIX,
} from '../dynamodb/dynamodb.constants';

/**
 * The Service to manage {@link TodoList}s.
 */
@Injectable()
export class ListService {
    private readonly logger = new Logger(ListService.name);

    constructor(private dynamodbService: DynamodbService) {}

    /**
     * Get all lists of the user.
     *
     * @param user {User} the user
     * @return {TodoList[]} the lists of the user
     */
    async getLists(user: User): Promise<TodoList[]> {
        this.logger.log('Getting lists of user ' + user.sub);
        const lists = await this.dynamodbService.getListsOfUser(
            USER_PARTITION_PREFIX + user.sub,
        );
        this.logger.debug(
            'Returning ' + lists.length + ' lists for ' + user.sub,
        );
        return lists;
    }

    /**
     * Create a new list.
     *
     * @param user {User} the owner of the list
     * @param listInfo {Partial<TodoList>} the information for the new list
     * @return {TodoList[]} returns all lists of the user
     */
    async createList(
        user: User,
        listInfo: Partial<TodoList>,
    ): Promise<TodoList[]> {
        const listID = uuidv4();
        this.logger.log(
            'Creating new list' + listID + ' for user ' + user.sub + '',
        );
        const list: TodoList = {
            partition: USER_PARTITION_PREFIX + user.sub,
            sort: LIST_PARTITION_PREFIX + listID,
            name: listInfo.name ?? 'New List',
            color: listInfo.color ?? 'warning',
            icon: listInfo.icon ?? 'check-circle-fill',
        };
        await this.dynamodbService.createList(list);
        return await this.getLists(user);
    }
}
