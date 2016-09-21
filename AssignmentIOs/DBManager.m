//
//  DBManager.m
//  AssignmentIOs
//
//  Created by Shailesh Patil on 21/09/16.
//  Copyright © 2016 Jyoti Shinde. All rights reserved.
//

#import "DBManager.h"
#import "ProductDetail.h"
static DBManager *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;


@implementation DBManager

+(DBManager*)getSharedInstance{
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance createDB];
    }
    return sharedInstance;
}

-(BOOL)createDB{
    NSString *docsDir;
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString:
                    [docsDir stringByAppendingPathComponent:@"CartData.db"]];
    BOOL isSuccess = YES;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            
           
            char *errMsg;
            const char *sql_stmt ="CREATE TABLE if not exists CartData (_id integer primary key autoincrement,productname VARCHAR ,price VARCHAR,phoneNumber VARCHAR,vendorname VARCHAR ,vendoraddress VARCHAR,productImg VARCHAR);";
            
            
           if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to create table");
            }
            sqlite3_close(database);
            return  isSuccess;
        }
        else {
            isSuccess = NO;
            NSLog(@"Failed to open/create database");
        }
    }
    return isSuccess;
}

-(BOOL) saveData:(NSString *)productName price:(NSString*)price
      phoneNumber:(NSString*)phoneNumber vendorname:(NSString*)vendorname vendoraddress:(NSString*)vendoraddress productImg:(NSString*)productImg;
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"insert into CartData (productname,price, phoneNumber, vendorname,vendoraddress,productImg) values (\"%@\",\"%@\", \"%@\",\"%@\",\"%@\", \"%@\")",productName,price,phoneNumber,vendorname,vendoraddress,productImg];
                               
        
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            return YES;
        }
        else {
            return NO;
        }
        sqlite3_reset(statement);
    }
    return NO;
}

-(NSMutableArray *)FindAllCartData{
    
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM CartData"];
        
        //@"productname,price, phoneNumber, vendorname,vendoraddress,productImg from CartData"
        
        
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK)
                              
        {
            
            ProductDetail *tempData=[[ProductDetail alloc]init];
            while(sqlite3_step(statement) == SQLITE_ROW)
             
            {
                
                tempData.productname = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                                  
                tempData.price=[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                tempData.phoneNumber=[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                tempData.vendorname=[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                tempData.vendoraddress=[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                tempData.productImg=[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
                [resultArray addObject:tempData];
                
                return resultArray;


            }

        }
    }
    return nil;

    
}
//- (NSArray*) findByRegisterNumber:(NSString*)registerNumber
//
//{
//    
//    const char *dbpath = [databasePath UTF8String];
//            if (sqlite3_open(dbpath, &database) == SQLITE_OK)
//            {
//                NSString *querySQL = [NSString stringWithFormat:@"select name, department, year from studentsDetail where regno=\"%@\"",registerNumber];
//
//
//                const char *query_stmt = [querySQL UTF8String];
//                NSMutableArray *resultArray = [[NSMutableArray alloc]init];
//                if (sqlite3_prepare_v2(database,
//                                       query_stmt, -1, &statement, NULL) == SQLITE_OK)
//                {
//                    if (sqlite3_step(statement) == SQLITE_ROW)
//                    {
//                        NSString *name = [[NSString alloc] initWithUTF8String:
//                                          (const char *) sqlite3_column_text(statement, 0)];
//                        [resultArray addObject:name];
//                        NSString *department = [[NSString alloc] initWithUTF8String:
//                                                (const char *) sqlite3_column_text(statement, 1)];
//                        [resultArray addObject:department];
//                        NSString *year = [[NSString alloc]initWithUTF8String:
//                                          (const char *) sqlite3_column_text(statement, 2)];
//                        [resultArray addObject:year];
//                        return resultArray;
//                    }
//                    else{
//                        NSLog(@"Not found");
//                        return nil;
//                    }
//                    sqlite3_reset(statement);
//                }
//            }
//            return nil;
//        }


//- (BOOL) saveData:(NSString*)registerNumber name:(NSString*)name
//       department:(NSString*)department year:(NSString*)year;
////{
//    const char *dbpath = [databasePath UTF8String];
//    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
//    {
//        NSString *insertSQL = [NSString stringWithFormat:@"insert into studentsDetail (regno,name, department, year) values (\"%d\",\"%@\", \"%@\", \"%@\")",[registerNumber integerValue],
//                               name, department, year];
//                               
//                               
//                                const char *insert_stmt = [insertSQL UTF8String];
//                                sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
//                                if (sqlite3_step(statement) == SQLITE_DONE)
//                                {
//                                    return YES;
//                                }
//                                else {
//                                    return NO;
//                                }
//                                sqlite3_reset(statement);
//                                }
//                                return NO;
//                                }

//                                - (NSArray*) findByRegisterNumber:(NSString*)registerNumber
//        {
//            const char *dbpath = [databasePath UTF8String];
//            if (sqlite3_open(dbpath, &database) == SQLITE_OK)
//            {
//                NSString *querySQL = [NSString stringWithFormat:@"select name, department, year from studentsDetail where regno=\"%@\"",registerNumber];
//
//                                      
//                const char *query_stmt = [querySQL UTF8String];
//                NSMutableArray *resultArray = [[NSMutableArray alloc]init];
//                if (sqlite3_prepare_v2(database,
//                                       query_stmt, -1, &statement, NULL) == SQLITE_OK)
//                {
//                    if (sqlite3_step(statement) == SQLITE_ROW)
//                    {
//                        NSString *name = [[NSString alloc] initWithUTF8String:
//                                          (const char *) sqlite3_column_text(statement, 0)];
//                        [resultArray addObject:name];
//                        NSString *department = [[NSString alloc] initWithUTF8String:
//                                                (const char *) sqlite3_column_text(statement, 1)];
//                        [resultArray addObject:department];
//                        NSString *year = [[NSString alloc]initWithUTF8String:
//                                          (const char *) sqlite3_column_text(statement, 2)];
//                        [resultArray addObject:year];
//                        return resultArray;
//                    }
//                    else{
//                        NSLog(@"Not found");
//                        return nil;
//                    }
//                    sqlite3_reset(statement);
//                }
//            }
//            return nil;
//        }
@end