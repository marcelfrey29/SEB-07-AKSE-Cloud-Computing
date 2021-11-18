import {
    Body,
    Controller,
    Get,
    Logger,
    Post,
    Req,
    Request,
} from '@nestjs/common';
import { ListService } from './list.service';
import { TodoList } from '../types/TodoList.interface';

/**
 * The Controller for managing {@link TodoList}s.
 */
@Controller('/lists')
export class ListController {
    private logger = new Logger(ListController.name);

    constructor(private listService: ListService) {}

    /**
     * Endpoint to get all lists.
     *
     * @param request {AuthorizedRequest} the request object with the user information
     */
    @Get()
    async getLists(@Request() request: AuthorizedRequest): Promise<TodoList[]> {
        this.logger.log('User ' + request.user.sub + ' requested all lists');
        return await this.listService.getLists(request.user);
    }

    /**
     * Endpoint to create a new list.
     *
     * @param request {AuthorizedRequest} the request object with the user information
     * @param listInfo {Partial<TodoList>} information of the new list
     */
    @Post()
    async createTodo(
        @Req() request: AuthorizedRequest,
        @Body() listInfo: Partial<TodoList>,
    ): Promise<TodoList[]> {
        this.logger.log('Create a new list for user ' + request.user.sub);
        return await this.listService.createList(request.user, listInfo);
    }
}
