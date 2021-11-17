import { Module } from '@nestjs/common';
import { ListController } from './list.controller';
import { ListService } from './list.service';
import { DynamodbModule } from '../dynamodb/dynamodb.module';

@Module({
    imports: [DynamodbModule],
    controllers: [ListController],
    providers: [ListService],
})
export class ListModule {}
