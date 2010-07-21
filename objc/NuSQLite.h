//
//  NuSQLite.h
//
//  Created by Tim Burks on 1/3/10.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@interface NuSQLite : NSObject {
	NSString *pathToDatabase;
	BOOL logging;
	sqlite3 *database;
}

@property (nonatomic, retain) NSString *pathToDatabase;
@property (nonatomic) BOOL logging;

- (id) initWithPath:(NSString *) filePath;
- (id) initWithFileName:(NSString *) fileName;
- (void) open;
- (void) close;
- (NSArray *) executeSQL:(NSString *) sql;
- (NSArray *) executeSQLWithParameters:(NSString *) sql, ...;
- (NSArray *) executeSQL:(NSString *) sql withParameters:(NSArray *) parameters;
- (NSArray *) executeSQL:(NSString *) sql withParameters:(NSArray *) parameters withClassForRow:(Class) rowClass;
- (NSArray *) tableNames;
- (NSArray *) columnsForTableName:(NSString *) tableName;
- (void) beginTransaction;
- (void) commit;
- (void) rollback;
- (NSUInteger) lastInsertRowId;
@end
