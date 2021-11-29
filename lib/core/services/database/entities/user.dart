// import 'package:floor/floor.dart';

// @entity
// class User {
//   @primaryKey
//   final int id;
//   final String name;
//   final String email;
//   final String accessToken;
//   final String phone;
//   final String image;
//   final int dateOfBirth;

//   User(this.id, this.name, this.accessToken, this.dateOfBirth, this.email, this.image, this.phone);
//   User.fromModel({this.id, this.name, this.email, this.accessToken, this.phone, this.image, this.dateOfBirth});
// }

// @dao
// abstract class UserDao {
//   @Query('SELECT * FROM User')
//   Future<List<User>> findAllUsers();

//   @Query('SELECT * FROM User')
//   Stream<List<User>> findAllTasksAsStream();

//   @Query('SELECT * FROM User WHERE id = :id')
//   Future<User> findUserById(int id);

//   @insert
//   Future<void> insertUser(User user);

//   @insert
//   Future<void> insertUsers(List<User> users);

//   @update
//   Future<void> updateUser(User user);

//   @update
//   Future<void> updateUsers(List<User> users);

//   @delete
//   Future<void> deleteUser(User user);

//   @delete
//   Future<void> deleteUsers(List<User> users);
// }
