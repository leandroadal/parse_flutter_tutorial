# Parse Server Integration Tutorial in Flutter

[Leia em Português](README.md)

This project uses the `parse_server_sdk_flutter` library to interact with Parse Server in a Flutter application, simplifying communication with the Parse API. The main function of the code is to perform CRUD (Create, Read, Update, Delete) operations on Parse objects within a Flutter environment.

---

## Dependencies

1. **flutter_dotenv**: Used to load environment variables from a `.env` file.
2. **parse_server_sdk_flutter**: Library responsible for interacting with Parse Server.

### Installing Dependencies

In a terminal within the project folder, execute:

```bash
flutter pub add parse_server_sdk_flutter
```

```Bash
flutter pub add flutter_dotenv
```

## Parse Server Configuration

The initializeParse function initializes the Parse SDK, configuring the `appId`, `clientKey`, and the `Parse API address`. The credentials should be loaded from the `.env` file using `dotenv`:

```Dart
Future<Parse> initializeParse() async {
  String appId = dotenv.env['PARSE_APP_ID_XLO'] ?? 'defaultAppId';
  String clientKey = dotenv.env['PARSE_CLIENT_KEY_XLO'] ?? 'defaultClientKey';

  return await Parse().initialize(
    appId,
    '[https://parseapi.back4app.com/](https://parseapi.back4app.com/)',
    clientKey: clientKey,
    autoSendSessionId: true,
    debug: true,
  );
}
```

## Parse Functions

### Create Record

Creates a new record in Parse.

```Dart
Future<ParseResponse> createData(
    {required String table,
    required String column,
    required dynamic data,
    required String column1,
    required dynamic data1}) async {
  final category = ParseObject(table)
    ..set(column, data)
    ..set(column1, data1);

  final response = await category.save();
  print(response.success);
  return response;
}
```

Usage Example:

```Dart
await createData(
  table: 'Categories',
  column: 'Title',
  data: 'Winter Sweaters',
  column1: 'Position',
  data1: 3,
);
```

### Update Record

Updates an existing record in Parse.

```Dart
Future<ParseResponse> updateData() async {
  final category = ParseObject('Categories')
    ..objectId = 'BJSgu61clb'
    ..set<int>('Position', 3);

  final response = await category.save();
  print(response.success);
  return response;
}
```

### Delete a Record

Deletes a specific record from Parse.

```Dart
Future<ParseResponse> deleteData() async {
  final category = ParseObject('Categories')..objectId = 'BJSgu61clb';

  final response = await category.delete();
  print(response.success);
  return response;
}
```

### Retrieve a Record by ID

Retrieves a specific record by its objectId.

```Dart
Future<void> getDataById() async {
  final response = await ParseObject('Categories').getObject('oBranFpS8M');
  if (response.success) {
    print(response.result);
  }
}
```

### Retrieve All Records from a Table

Retrieves all records from the Categories table.

```Dart
Future<void> getAllData() async {
  final response = await ParseObject('Categories').getAll();
  if (response.success) {
    for (var element in response.result) {
      print(element);
    }
  }
}
```

### Search Filters

#### equalsTo (Query Builder)

Filters records where the Position field has the value 2.

```Dart
Future<ParseResponse> equalsTo(QueryBuilder<ParseObject> query) async {
  query.whereEqualTo('Position', 2);

  final response = await query.query();
  if (response.success) {
    print(response.result);
  }
  return response;
}
```

#### whereContains (Query Builder)

Filters records where the Title field contains the substring "Sweaters".

```Dart
Future<void> whereContains(QueryBuilder<ParseObject> query) async {
  query.whereContains('Title', 'Sweaters');

  final response = await query.query();
  if (response.success) {
    print(response.result);
  }
}
