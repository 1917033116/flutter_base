import 'package:sqflite/sqflite.dart';

abstract class BaseProvider<T> {
  Database db;

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int verson) async {
      await db.execute("create table ${getTableName()} (${getCreateStr()})");
    });
  }

  String getCreateStr();

  String getTableName();

  Future<T> insert(T t);

  Future<T> getRowById(int id);

  Future<int> update(T t);

  Future close();
}

abstract class BaseDbBean {
  Map<String, dynamic> toMap();

  BaseDbBean.fromMap(Map<String, dynamic> map);
}
