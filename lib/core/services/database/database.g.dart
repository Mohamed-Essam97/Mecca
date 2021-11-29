// // GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// // **************************************************************************
// // FloorGenerator
// // **************************************************************************

class $FloorAppDatabase {
//   /// Creates a database builder for a persistent database.
//   /// Once a database is built, you should keep a reference to it and re-use it.
//   static _$AppDatabaseBuilder databaseBuilder(String name) =>
//       _$AppDatabaseBuilder(name);

//   /// Creates a database builder for an in memory database.
//   /// Information stored in an in memory database disappears when the process is killed.
//   /// Once a database is built, you should keep a reference to it and re-use it.
//   static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
//       _$AppDatabaseBuilder(null);
// }

// class _$AppDatabaseBuilder {
//   _$AppDatabaseBuilder(this.name);

//   final String name;

//   final List<Migration> _migrations = [];

//   Callback _callback;

//   /// Adds migrations to the builder.
//   _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
//     _migrations.addAll(migrations);
//     return this;
//   }

//   /// Adds a database [Callback] to the builder.
//   _$AppDatabaseBuilder addCallback(Callback callback) {
//     _callback = callback;
//     return this;
//   }

//   /// Creates the database and initializes it.
//   Future<AppDatabase> build() async {
//     final path = name != null
//         ? join(await sqflite.getDatabasesPath(), name)
//         : ':memory:';
//     final database = _$AppDatabase();
//     database.database = await database.open(
//       path,
//       _migrations,
//       _callback,
//     );
//     return database;
//   }
// }

// class _$AppDatabase extends AppDatabase {
//   _$AppDatabase([StreamController<String> listener]) {
//     changeListener = listener ?? StreamController<String>.broadcast();
//   }

//   UserDao _userDaoInstance;

//   ItemDao _itemDaoInstance;

//   CartItemDao _cartItemDaoInstance;

//   NotificationDeo _notificationDeoInstance;

//   SearchDeo _searchDeoInstance;

//   Future<sqflite.Database> open(String path, List<Migration> migrations,
//       [Callback callback]) async {
//     return sqflite.openDatabase(
//       path,
//       version: 1,
//       onConfigure: (database) async {
//         await database.execute('PRAGMA foreign_keys = ON');
//       },
//       onOpen: (database) async {
//         await callback?.onOpen?.call(database);
//       },
//       onUpgrade: (database, startVersion, endVersion) async {
//         MigrationAdapter.runMigrations(
//             database, startVersion, endVersion, migrations);

//         await callback?.onUpgrade?.call(database, startVersion, endVersion);
//       },
//       onCreate: (database, version) async {
//         await database.execute(
//             'CREATE TABLE IF NOT EXISTS `User` (`id` INTEGER, `name` TEXT, `email` TEXT, `accessToken` TEXT, `phone` TEXT, `image` TEXT, `dateOfBirth` INTEGER, PRIMARY KEY (`id`))');
//         await database.execute(
//             'CREATE TABLE IF NOT EXISTS `ItemModel` (`id` INTEGER, `stock` TEXT, `price` TEXT, `discount` TEXT, `tags` TEXT, `status` TEXT, `offerId` TEXT, `mainImage` TEXT, `createdAt` TEXT, `updatedAt` TEXT, `name` TEXT, `descr` TEXT, `timestamp` INTEGER, PRIMARY KEY (`id`))');
//         await database.execute(
//             'CREATE TABLE IF NOT EXISTS `CartItem` (`id` INTEGER, `stock` TEXT, `price` TEXT, `discount` TEXT, `tags` TEXT, `status` TEXT, `offerId` TEXT, `mainImage` TEXT, `createdAt` TEXT, `updatedAt` TEXT, `name` TEXT, `descr` TEXT, `numberOfItem` INTEGER, `timestamp` INTEGER, PRIMARY KEY (`id`))');
//         await database.execute(
//             'CREATE TABLE IF NOT EXISTS `NotificationItem` (`id` INTEGER, `messageAr` TEXT, `messageEn` TEXT, `titleAr` TEXT, `titleEn` TEXT, `offerId` INTEGER, `timestamp` INTEGER, `isSeen` INTEGER, PRIMARY KEY (`id`))');
//         await database.execute(
//             'CREATE TABLE IF NOT EXISTS `SearchModel` (`text` TEXT, `timeStamp` INTEGER, `type` INTEGER, PRIMARY KEY (`text`))');

//         await callback?.onCreate?.call(database, version);
//       },
//     );
//   }

//   @override
//   UserDao get userDao {
//     return _userDaoInstance ??= _$UserDao(database, changeListener);
//   }

//   @override
//   ItemDao get itemDao {
//     return _itemDaoInstance ??= _$ItemDao(database, changeListener);
//   }

//   @override
//   CartItemDao get cartItemDao {
//     return _cartItemDaoInstance ??= _$CartItemDao(database, changeListener);
//   }

//   @override
//   NotificationDeo get notificationDeo {
//     return _notificationDeoInstance ??=
//         _$NotificationDeo(database, changeListener);
//   }

//   @override
//   SearchDeo get searchDeo {
//     return _searchDeoInstance ??= _$SearchDeo(database, changeListener);
//   }
// }

// class _$UserDao extends UserDao {
//   _$UserDao(this.database, this.changeListener)
//       : _queryAdapter = QueryAdapter(database, changeListener),
//         _userInsertionAdapter = InsertionAdapter(
//             database,
//             'User',
//             (User item) => <String, dynamic>{
//                   'id': item.id,
//                   'name': item.name,
//                   'email': item.email,
//                   'accessToken': item.accessToken,
//                   'phone': item.phone,
//                   'image': item.image,
//                   'dateOfBirth': item.dateOfBirth
//                 },
//             changeListener),
//         _userUpdateAdapter = UpdateAdapter(
//             database,
//             'User',
//             ['id'],
//             (User item) => <String, dynamic>{
//                   'id': item.id,
//                   'name': item.name,
//                   'email': item.email,
//                   'accessToken': item.accessToken,
//                   'phone': item.phone,
//                   'image': item.image,
//                   'dateOfBirth': item.dateOfBirth
//                 },
//             changeListener),
//         _userDeletionAdapter = DeletionAdapter(
//             database,
//             'User',
//             ['id'],
//             (User item) => <String, dynamic>{
//                   'id': item.id,
//                   'name': item.name,
//                   'email': item.email,
//                   'accessToken': item.accessToken,
//                   'phone': item.phone,
//                   'image': item.image,
//                   'dateOfBirth': item.dateOfBirth
//                 },
//             changeListener);

//   final sqflite.DatabaseExecutor database;

//   final StreamController<String> changeListener;

//   final QueryAdapter _queryAdapter;

//   static final _userMapper = (Map<String, dynamic> row) => User(
//       row['id'] as int,
//       row['name'] as String,
//       row['accessToken'] as String,
//       row['dateOfBirth'] as int,
//       row['email'] as String,
//       row['image'] as String,
//       row['phone'] as String);

//   final InsertionAdapter<User> _userInsertionAdapter;

//   final UpdateAdapter<User> _userUpdateAdapter;

//   final DeletionAdapter<User> _userDeletionAdapter;

//   @override
//   Future<List<User>> findAllUsers() async {
//     return _queryAdapter.queryList('SELECT * FROM User', mapper: _userMapper);
//   }

//   @override
//   Stream<List<User>> findAllTasksAsStream() {
//     return _queryAdapter.queryListStream('SELECT * FROM User',
//         tableName: 'User', mapper: _userMapper);
//   }

//   @override
//   Future<User> findUserById(int id) async {
//     return _queryAdapter.query('SELECT * FROM User WHERE id = ?',
//         arguments: <dynamic>[id], mapper: _userMapper);
//   }

//   @override
//   Future<void> insertUser(User user) async {
//     await _userInsertionAdapter.insert(user, sqflite.ConflictAlgorithm.abort);
//   }

//   @override
//   Future<void> insertUsers(List<User> users) async {
//     await _userInsertionAdapter.insertList(
//         users, sqflite.ConflictAlgorithm.abort);
//   }

//   @override
//   Future<void> updateUser(User user) async {
//     await _userUpdateAdapter.update(user, sqflite.ConflictAlgorithm.abort);
//   }

//   @override
//   Future<void> updateUsers(List<User> users) async {
//     await _userUpdateAdapter.updateList(users, sqflite.ConflictAlgorithm.abort);
//   }

//   @override
//   Future<void> deleteUser(User user) async {
//     await _userDeletionAdapter.delete(user);
//   }

//   @override
//   Future<void> deleteUsers(List<User> users) async {
//     await _userDeletionAdapter.deleteList(users);
//   }
// }

// class _$ItemDao extends ItemDao {
//   _$ItemDao(this.database, this.changeListener)
//       : _queryAdapter = QueryAdapter(database),
//         _itemModelInsertionAdapter = InsertionAdapter(
//             database,
//             'ItemModel',
//             (ItemModel item) => <String, dynamic>{
//                   'id': item.id,
//                   'stock': item.stock,
//                   'price': item.price,
//                   'discount': item.discount,
//                   'tags': item.tags,
//                   'status': item.status,
//                   'offerId': item.offerId,
//                   'mainImage': item.mainImage,
//                   'createdAt': item.createdAt,
//                   'updatedAt': item.updatedAt,
//                   'name': item.name,
//                   'descr': item.descr,
//                   'timestamp': item.timestamp
//                 }),
//         _itemModelUpdateAdapter = UpdateAdapter(
//             database,
//             'ItemModel',
//             ['id'],
//             (ItemModel item) => <String, dynamic>{
//                   'id': item.id,
//                   'stock': item.stock,
//                   'price': item.price,
//                   'discount': item.discount,
//                   'tags': item.tags,
//                   'status': item.status,
//                   'offerId': item.offerId,
//                   'mainImage': item.mainImage,
//                   'createdAt': item.createdAt,
//                   'updatedAt': item.updatedAt,
//                   'name': item.name,
//                   'descr': item.descr,
//                   'timestamp': item.timestamp
//                 });

//   final sqflite.DatabaseExecutor database;

//   final StreamController<String> changeListener;

//   final QueryAdapter _queryAdapter;

//   static final _itemModelMapper = (Map<String, dynamic> row) => ItemModel(
//       id: row['id'] as int,
//       stock: row['stock'] as String,
//       price: row['price'] as String,
//       discount: row['discount'] as String,
//       tags: row['tags'] as String,
//       status: row['status'] as String,
//       offerId: row['offerId'] as String,
//       mainImage: row['mainImage'] as String,
//       createdAt: row['createdAt'] as String,
//       updatedAt: row['updatedAt'] as String,
//       name: row['name'] as String,
//       descr: row['descr'] as String);

//   final InsertionAdapter<ItemModel> _itemModelInsertionAdapter;

//   final UpdateAdapter<ItemModel> _itemModelUpdateAdapter;

//   @override
//   Future<List<ItemModel>> findAllItems() async {
//     return _queryAdapter.queryList('SELECT * FROM ItemModel',
//         mapper: _itemModelMapper);
//   }

//   @override
//   Future<ItemModel> findItemById(int id) async {
//     return _queryAdapter.query('SELECT * FROM ItemModel WHERE id = ?',
//         arguments: <dynamic>[id], mapper: _itemModelMapper);
//   }

//   @override
//   Future<void> deleteItem(int id) async {
//     await _queryAdapter.queryNoReturn('DELETE FROM ItemModel WHERE id= ?',
//         arguments: <dynamic>[id]);
//   }

//   @override
//   Future<List<ItemModel>> countBiggerThanTimeStamp(int timestamp) async {
//     return _queryAdapter.queryList(
//         'SELECT * FROM ItemModel WHERE timestamp > ?',
//         arguments: <dynamic>[timestamp],
//         mapper: _itemModelMapper);
//   }

//   @override
//   Future<void> clear() async {
//     await _queryAdapter.queryNoReturn('DELETE FROM ItemModel');
//   }

//   @override
//   Future<void> insertItem(ItemModel item) async {
//     await _itemModelInsertionAdapter.insert(
//         item, sqflite.ConflictAlgorithm.abort);
//   }

//   @override
//   Future<int> updateItems(List<ItemModel> item) {
//     return _itemModelUpdateAdapter.updateListAndReturnChangedRows(
//         item, sqflite.ConflictAlgorithm.abort);
//   }
// }

// class _$CartItemDao extends CartItemDao {
//   _$CartItemDao(this.database, this.changeListener)
//       : _queryAdapter = QueryAdapter(database),
//         _cartItemInsertionAdapter = InsertionAdapter(
//             database,
//             'CartItem',
//             (CartItem item) => <String, dynamic>{
//                   'id': item.id,
//                   'stock': item.stock,
//                   'price': item.price,
//                   'discount': item.discount,
//                   'tags': item.tags,
//                   'status': item.status,
//                   'offerId': item.offerId,
//                   'mainImage': item.mainImage,
//                   'createdAt': item.createdAt,
//                   'updatedAt': item.updatedAt,
//                   'name': item.name,
//                   'descr': item.descr,
//                   'numberOfItem': item.numberOfItem,
//                   'timestamp': item.timestamp
//                 }),
//         _cartItemUpdateAdapter = UpdateAdapter(
//             database,
//             'CartItem',
//             ['id'],
//             (CartItem item) => <String, dynamic>{
//                   'id': item.id,
//                   'stock': item.stock,
//                   'price': item.price,
//                   'discount': item.discount,
//                   'tags': item.tags,
//                   'status': item.status,
//                   'offerId': item.offerId,
//                   'mainImage': item.mainImage,
//                   'createdAt': item.createdAt,
//                   'updatedAt': item.updatedAt,
//                   'name': item.name,
//                   'descr': item.descr,
//                   'numberOfItem': item.numberOfItem,
//                   'timestamp': item.timestamp
//                 });

//   final sqflite.DatabaseExecutor database;

//   final StreamController<String> changeListener;

//   final QueryAdapter _queryAdapter;

//   static final _cartItemMapper = (Map<String, dynamic> row) => CartItem(
//       id: row['id'] as int,
//       stock: row['stock'] as String,
//       price: row['price'] as String,
//       discount: row['discount'] as String,
//       tags: row['tags'] as String,
//       status: row['status'] as String,
//       offerId: row['offerId'] as String,
//       mainImage: row['mainImage'] as String,
//       createdAt: row['createdAt'] as String,
//       updatedAt: row['updatedAt'] as String,
//       name: row['name'] as String,
//       descr: row['descr'] as String,
//       numberOfItem: row['numberOfItem'] as int);

//   final InsertionAdapter<CartItem> _cartItemInsertionAdapter;

//   final UpdateAdapter<CartItem> _cartItemUpdateAdapter;

//   @override
//   Future<List<CartItem>> findAllItems() async {
//     return _queryAdapter.queryList('SELECT * FROM CartItem',
//         mapper: _cartItemMapper);
//   }

//   @override
//   Future<CartItem> findItemById(int id) async {
//     return _queryAdapter.query('SELECT * FROM CartItem WHERE id = ?',
//         arguments: <dynamic>[id], mapper: _cartItemMapper);
//   }

//   @override
//   Future<void> deleteItem(int id) async {
//     await _queryAdapter.queryNoReturn('DELETE FROM CartItem WHERE id= ?',
//         arguments: <dynamic>[id]);
//   }

//   @override
//   Future<void> updateItem(int numberOfItem, int timestamp, int id) async {
//     await _queryAdapter.queryNoReturn(
//         'UPDATE CartItem SET numberOfItem = ? , timestamp =? WHERE id = ?',
//         arguments: <dynamic>[numberOfItem, timestamp, id]);
//   }

//   @override
//   Future<List<CartItem>> countBiggerThanTimeStamp(int timestamp) async {
//     return _queryAdapter.queryList('SELECT * FROM CartItem WHERE timestamp > ?',
//         arguments: <dynamic>[timestamp], mapper: _cartItemMapper);
//   }

//   @override
//   Future<void> clear() async {
//     await _queryAdapter.queryNoReturn('DELETE FROM CartItem');
//   }

//   @override
//   Future<void> insertItem(CartItem item) async {
//     await _cartItemInsertionAdapter.insert(
//         item, sqflite.ConflictAlgorithm.abort);
//   }

//   @override
//   Future<int> updateItems(List<CartItem> item) {
//     return _cartItemUpdateAdapter.updateListAndReturnChangedRows(
//         item, sqflite.ConflictAlgorithm.abort);
//   }
// }

// class _$NotificationDeo extends NotificationDeo {
//   _$NotificationDeo(this.database, this.changeListener)
//       : _queryAdapter = QueryAdapter(database),
//         _notificationItemInsertionAdapter = InsertionAdapter(
//             database,
//             'NotificationItem',
//             (NotificationItem item) => <String, dynamic>{
//                   'id': item.id,
//                   'messageAr': item.messageAr,
//                   'messageEn': item.messageEn,
//                   'titleAr': item.titleAr,
//                   'titleEn': item.titleEn,
//                   'offerId': item.offerId,
//                   'timestamp': item.timestamp,
//                   'isSeen': item.isSeen ? 1 : 0
//                 });

//   final sqflite.DatabaseExecutor database;

//   final StreamController<String> changeListener;

//   final QueryAdapter _queryAdapter;

//   static final _notificationItemMapper = (Map<String, dynamic> row) =>
//       NotificationItem(
//           id: row['id'] as int,
//           messageAr: row['messageAr'] as String,
//           messageEn: row['messageEn'] as String,
//           titleAr: row['titleAr'] as String,
//           titleEn: row['titleEn'] as String,
//           offerId: row['offerId'] as int,
//           timestamp: row['timestamp'] as int,
//           isSeen: (row['isSeen'] as int) != 0);

//   final InsertionAdapter<NotificationItem> _notificationItemInsertionAdapter;

//   @override
//   Future<List<NotificationItem>> findAllItems() async {
//     return _queryAdapter.queryList('SELECT * FROM NotificationItem',
//         mapper: _notificationItemMapper);
//   }

//   @override
//   Future<NotificationItem> findItemByID(int id) async {
//     return _queryAdapter.query('SELECT * FROM NotificationItem where id =?',
//         arguments: <dynamic>[id], mapper: _notificationItemMapper);
//   }

//   @override
//   Future<void> markAsSeen(int id) async {
//     await _queryAdapter.queryNoReturn(
//         'UPDATE NotificationItem SET isSeen = 1 WHERE id = ?',
//         arguments: <dynamic>[id]);
//   }

//   @override
//   Future<List<NotificationItem>> getSeenOrUnSeenItems(bool seen) async {
//     return _queryAdapter.queryList(
//         'SELECT * FROM NotificationItem WHERE isSeen is ?',
//         arguments: <dynamic>[seen],
//         mapper: _notificationItemMapper);
//   }

//   @override
//   Future<void> clear() async {
//     await _queryAdapter.queryNoReturn('DELETE FROM NotificationItem');
//   }

//   @override
//   Future<void> insertItem(NotificationItem item) async {
//     await _notificationItemInsertionAdapter.insert(
//         item, sqflite.ConflictAlgorithm.abort);
//   }
// }

// class _$SearchDeo extends SearchDeo {
//   _$SearchDeo(this.database, this.changeListener)
//       : _queryAdapter = QueryAdapter(database),
//         _searchModelInsertionAdapter = InsertionAdapter(
//             database,
//             'SearchModel',
//             (SearchModel item) => <String, dynamic>{
//                   'text': item.text,
//                   'timeStamp': item.timeStamp,
//                   'type': item.type
//                 });

//   final sqflite.DatabaseExecutor database;

//   final StreamController<String> changeListener;

//   final QueryAdapter _queryAdapter;

//   static final _searchModelMapper = (Map<String, dynamic> row) => SearchModel(
//       text: row['text'] as String,
//       timeStamp: row['timeStamp'] as int,
//       type: row['type'] as int);

//   final InsertionAdapter<SearchModel> _searchModelInsertionAdapter;

//   @override
//   Future<List<SearchModel>> findAllItems(int type) async {
//     return _queryAdapter.queryList(
//         'SELECT * FROM SearchModel where type = ? ORDER BY timeStamp DESC',
//         arguments: <dynamic>[type],
//         mapper: _searchModelMapper);
//   }

//   @override
//   Future<SearchModel> findItemByText(String text, int type) async {
//     return _queryAdapter.query(
//         'SELECT * FROM SearchModel where text =? & type = ?',
//         arguments: <dynamic>[text, type],
//         mapper: _searchModelMapper);
//   }

//   @override
//   Future<void> updateItem(int timestamp, String text, int type) async {
//     await _queryAdapter.queryNoReturn(
//         'UPDATE SearchModel SET timestamp = ? WHERE text = ? & type = ?',
//         arguments: <dynamic>[timestamp, text, type]);
//   }

//   @override
//   Future<void> clear() async {
//     await _queryAdapter.queryNoReturn('DELETE FROM SearchModel');
//   }

//   @override
//   Future<void> insertItem(SearchModel item) async {
//     await _searchModelInsertionAdapter.insert(
//         item, sqflite.ConflictAlgorithm.abort);
//   }
}
