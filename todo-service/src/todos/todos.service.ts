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
            partitionKey: LIST_PARTITION_PREFIX + list,
            sortKey: TODO_PARTITION_PREFIX + todoId,
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

    /**
     * Update an existing task.
     *
     * @param user {User} the user
     * @param list {string} the unique id of the list where the task belongs to
     * @param task {string} the unique id of the task to update
     * @param todoData {Partial<TodoElement>} the new data to update the task with
     * @return {TodoElement[]} returns all task in the list, including the updated one
     */
    async editTodo(
        user: User,
        list: string,
        task: string,
        todoData: Partial<TodoElement>,
    ): Promise<TodoElement[]> {
        this.logger.log(
            'Updating the todo ' +
                task +
                ' in list ' +
                list +
                ' for user ' +
                user.sub,
        );
        const existingTodo: TodoElement =
            await this.dynamodbService.getTodoById(
                LIST_PARTITION_PREFIX + list,
                TODO_PARTITION_PREFIX + task,
            );
        if (existingTodo.owner !== user.sub) {
            this.logger.warn(
                'User mismatch: ' +
                    user.sub +
                    ' is not the owner of todo ' +
                    existingTodo.sortKey +
                    '. (' +
                    existingTodo.owner +
                    ' is the correct owner!',
            );
            throw new Error('User Mismatch');
        }

        const todoElement: TodoElement = {
            partitionKey: LIST_PARTITION_PREFIX + list,
            sortKey: TODO_PARTITION_PREFIX + task,
            title: todoData.title ?? '',
            description: todoData.description ?? '',
            dueDate: todoData.dueDate ?? '',
            isFlagged: todoData.isFlagged ?? false,
            tags: todoData.tags ?? [],
            isDone: todoData.isDone ?? false,
            owner: user.sub,
        };
        await this.dynamodbService.updateTodoElement(todoElement);
        return await this.getTodos(user, list);
    }

    /**
     * Delete an existing task.
     *
     * @param user {User} the user
     * @param list {string} the unique id of the list where the task belongs to
     * @param task {string} the unique id of the task to delete
     * @return {TodoElement[]} returns all remaining task in the list
     */
    async deleteTodo(user: User, list: string, task: string) {
        this.logger.log(
            'Delete the todo ' +
                task +
                ' in list ' +
                list +
                ' for user ' +
                user.sub,
        );
        const existingTodo: TodoElement =
            await this.dynamodbService.getTodoById(
                LIST_PARTITION_PREFIX + list,
                TODO_PARTITION_PREFIX + task,
            );
        if (existingTodo.owner !== user.sub) {
            this.logger.warn(
                'User mismatch: ' +
                    user.sub +
                    ' is not the owner of todo ' +
                    existingTodo.sortKey +
                    '. (' +
                    existingTodo.owner +
                    ' is the correct owner!',
            );
            throw new Error('User Mismatch');
        }

        const todoElement: Partial<TodoElement> = {
            partitionKey: LIST_PARTITION_PREFIX + list,
            sortKey: TODO_PARTITION_PREFIX + task,
        };
        await this.dynamodbService.deleteTodoElement(todoElement);
        return await this.getTodos(user, list);
    }
}
