// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// BeanGenerator
// **************************************************************************

abstract class _UserBean implements Bean<User> {
  final id = IntField('id');
  final userName = StrField('user_name');
  final pwd = StrField('pwd');
  final nickName = StrField('nick_name');
  final userHeader = StrField('user_header');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        id.name: id,
        userName.name: userName,
        pwd.name: pwd,
        nickName.name: nickName,
        userHeader.name: userHeader,
      };
  User fromMap(Map map) {
    User model = User();
    model.id = adapter.parseValue(map['id']);
    model.userName = adapter.parseValue(map['user_name']);
    model.pwd = adapter.parseValue(map['pwd']);
    model.nickName = adapter.parseValue(map['nick_name']);
    model.userHeader = adapter.parseValue(map['user_header']);

    return model;
  }

  List<SetColumn> toSetColumns(User model,
      {bool update = false, Set<String> only}) {
    List<SetColumn> ret = [];

    if (only == null) {
      if (model.id != null) {
        ret.add(id.set(model.id));
      }
      ret.add(userName.set(model.userName));
      ret.add(pwd.set(model.pwd));
      ret.add(nickName.set(model.nickName));
      ret.add(userHeader.set(model.userHeader));
    } else {
      if (model.id != null) {
        if (only.contains(id.name)) ret.add(id.set(model.id));
      }
      if (only.contains(userName.name)) ret.add(userName.set(model.userName));
      if (only.contains(pwd.name)) ret.add(pwd.set(model.pwd));
      if (only.contains(nickName.name)) ret.add(nickName.set(model.nickName));
      if (only.contains(userHeader.name))
        ret.add(userHeader.set(model.userHeader));
    }

    return ret;
  }

  Future<void> createTable({bool ifNotExists: false}) async {
    final st = Sql.create(tableName, ifNotExists: ifNotExists);
    st.addInt(id.name, primary: true, autoIncrement: true, isNullable: false);
    st.addStr(userName.name, isNullable: false);
    st.addStr(pwd.name, isNullable: false);
    st.addStr(nickName.name, isNullable: false);
    st.addStr(userHeader.name, isNullable: true);
    return adapter.createTable(st);
  }

  Future<dynamic> insert(User model, {bool cascade: false}) async {
    final Insert insert = inserter.setMany(toSetColumns(model)).id(id.name);
    var retId = await adapter.insert(insert);
    if (cascade) {
      User newModel;
    }
    return retId;
  }

  Future<void> insertMany(List<User> models) async {
    final List<List<SetColumn>> data =
        models.map((model) => toSetColumns(model)).toList();
    final InsertMany insert = inserters.addAll(data);
    await adapter.insertMany(insert);
    return;
  }

  Future<dynamic> upsert(User model, {bool cascade: false}) async {
    final Upsert upsert = upserter.setMany(toSetColumns(model)).id(id.name);
    var retId = await adapter.upsert(upsert);
    if (cascade) {
      User newModel;
    }
    return retId;
  }

  Future<void> upsertMany(List<User> models) async {
    final List<List<SetColumn>> data = [];
    for (var i = 0; i < models.length; ++i) {
      var model = models[i];
      data.add(toSetColumns(model).toList());
    }
    final UpsertMany upsert = upserters.addAll(data);
    await adapter.upsertMany(upsert);
    return;
  }

  Future<int> update(User model, {Set<String> only}) async {
    final Update update = updater
        .where(this.id.eq(model.id))
        .setMany(toSetColumns(model, only: only));
    return adapter.update(update);
  }

  Future<void> updateMany(List<User> models) async {
    final List<List<SetColumn>> data = [];
    final List<Expression> where = [];
    for (var i = 0; i < models.length; ++i) {
      var model = models[i];
      data.add(toSetColumns(model).toList());
      where.add(this.id.eq(model.id));
    }
    final UpdateMany update = updaters.addAll(data, where);
    await adapter.updateMany(update);
    return;
  }

  Future<User> find(int id, {bool preload: false, bool cascade: false}) async {
    final Find find = finder.where(this.id.eq(id));
    return await findOne(find);
  }

  Future<int> remove(int id) async {
    final Remove remove = remover.where(this.id.eq(id));
    return adapter.remove(remove);
  }

  Future<int> removeMany(List<User> models) async {
    final Remove remove = remover;
    for (final model in models) {
      remove.or(this.id.eq(model.id));
    }
    return adapter.remove(remove);
  }
}
