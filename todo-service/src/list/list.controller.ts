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
import { Unprotected } from 'nest-keycloak-connect';

/**
 *
 */
@Controller('/lists')
export class ListController {
    private logger = new Logger(ListController.name);

    constructor(private listService: ListService) {}

    /**
     * Endpoint to get a new list
     *
     * @param request {AuthorizedRequest} the request object with the user information
     */
    @Get()
    @Unprotected()
    getLists(@Request() request: AuthorizedRequest): TodoList[] {
        this.logger.log('User ' + request.user.sid + ' requested its lists');
        return this.listService.getLists(request.user);
    }

    /**
     * Endpoint to create a new list
     *
     * @param request {AuthorizedRequest} the request object with the user information
     * @param listInfo {Partial<TodoList>} information of the new list
     */
    @Post()
    createTodo(
        @Req() request: AuthorizedRequest,
        @Body() listInfo: Partial<TodoList>,
    ): TodoList {
        this.logger.log('Create a new list for user ' + request.user.sid);
        return this.listService.createList(request.user, listInfo);
    }
}
