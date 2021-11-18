import { Injectable, Logger } from '@nestjs/common';
import { DynamodbService } from '../dynamodb/dynamodb.service';
import {
    LIST_PARTITION_PREFIX,
    TODO_PARTITION_PREFIX,
} from '../dynamodb/dynamodb.constants';
import { TodoElement } from '../types/Todo.interface';
import { v4 as uuidv4 } from 'uuid';

/**
 *
 */
@Injectable()
export class TodosService {
    private readonly logger = new Logger(TodosService.name);

    constructor(private dynamodbService: DynamodbService) {}

    /**
     * Get all todos from a user in a list.
     *
     * @param user {User} the user that requests the todos
     * @param list {string} the unique id of the list
     * @return {TodoElement[]} the list of todos in the given list
     */
    async getTodos(user: User, list: string): Promise<TodoElement[]> {
        this.logger.log(
            'Getting all todos of the list ' + list + ' of user ' + user.sub,
        );
        const todos = await this.dynamodbService.getTodosOfList(
            LIST_PARTITION_PREFIX + list,
        );
        // TODO: Check owner? (for each todo?)
        this.logger.debug(
            'Returning ' +
                todos.length +
                ' todos for the list ' +
                list +
                ' of ' +
                user.sub,
        );
        return todos;
    }

    /**
     * Add a new Element to a list.
     *
     * @param user {User} the user that wants to add an element to the list
     * @param list {string} the unique id of the list to add the element
     * @param todoData {Partial<TodoElement>} the infos of the new element
     * @return {TodoElement[]} return all elements of the given list, including the new one
     */
    async addTodo(
        user: User,
        list: string,
        todoData: Partial<TodoElement>,
    ): Promise<TodoElement[]> {
        const todoId = uuidv4();
        this.logger.log(
            'Creating a new element ' +
                todoId +
                ' in list ' +
                list +
                ' for user ' +
                user.sub,
        );
        const todoElement: TodoElement = {
            partition: LIST_PARTITION_PREFIX + list,
            sort: TODO_PARTITION_PREFIX + todoId,
            title: todoData.title ?? '',
            description: todoData.description ?? '',
            dueDate: todoData.dueDate ?? '',
            isFlagged: todoData.isFlagged ?? false,
            tags: todoData.tags ?? [],
            isDone: false,
            owner: user.sub,
        };
        await this.dynamodbService.createTodoElementInList(todoElement);
        return await this.getTodos(user, list);
    }
}
