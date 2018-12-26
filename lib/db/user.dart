import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_orm/jaguar_orm.dart';
import 'package:jaguar_query_sqflite/jaguar_query_sqflite.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

part 'user.jorm.dart';

class User {
  User();

  User.make();

  @PrimaryKey(auto: true)
  int id;
  @Column(isNullable: false)
  String userName;
  @Column(isNullable: false)
  String pwd;
  @Column(isNullable: false)
  String nickName;
  @Column(isNullable: true)
  String userHeader;

  @override
  String toString() {
    return 'User(id: $id, userName: $userName, pwd: $pwd, nickName: $nickName,userHeader:$userHeader)';
  }

  static String get tableName => 'users';
}

@GenBean()
class UserBean extends Bean<User> with _UserBean {
  UserBean(Adapter adapter) : super(adapter);

  @override
  String get tableName => 'users';

  Future<User> findOneByUserName(String userNameWhere) {
    Find st = Sql.find(tableName)
        .sel('$tableName.*')
        .where(Field.inTable(tableName, userName.name).eq(userNameWhere));
    return findOne(st);
  }

  void close() {
    if (adapter != null) adapter.close();
  }
}

class UserManager {
  static final String _NAME = "users.db";

  static Future<UserBean> userBean() async {
    String dbPath = await getDatabasesPath();
    SqfliteAdapter adapter = SqfliteAdapter(path.join(dbPath, _NAME));
    await adapter.connect();
    final bean = UserBean(adapter);
    bool isTableExits = await _isTableExits();
    if (!isTableExits) bean.createTable();
    return bean;
  }

  static Future<bool> _isTableExits() async {
    String dbPath = await getDatabasesPath();
    Database _database = await openDatabase("$dbPath$_NAME");
    var res = await _database.rawQuery(
        "select * from Sqlite_master where type='table' and name='${User.tableName}'");
    bool isTableExits;
    if (res != null && res.length > 0) {
      isTableExits = true;
    } else {
      isTableExits = false;
    }
    return isTableExits;
  }
}
