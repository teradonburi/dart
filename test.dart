import 'dart:async'; // 非同期処理
import 'dart:io';
import "dart:isolate"; // アイソレータ

// main関数は処理のエントリポイント（この内部で処理が始まる）
main() async {
  // コメント
  var a = 1; // varで変数定義、dartは末尾セミコロン必須
  print(a);
  a = 2;
  print('\$で変数パラメータ埋め込み、$a');

  // 四則演算(+, -, *, /, %)
  print(1 + 2 - 3 * 4 / 5 % 6);

  // dartのbuild-in型（明示的な型宣言変数）
  int b = 10;
  double c = 12.3;
  String d = 'abc';
  bool e = true;
  print('$b, $c, $d, $e');
  List f = [1,2,3]; // 配列
  f.add(4);  // 末尾追加
  f.add(4);
  print('$f, ${f.length}, ${f[0]}');
  Set g = {'a', 'b', 'c'}; // 重複を許さない配列
  g.add('d');  // 末尾追加
  g.add('d');  // 重複して入ることはない
  print('$g, ${g.length}, ${g.toList()[1]}'); // 配列に変換するときはtoListを使う
  // Key/Valueペア
  Map h = {
    // Key: Value
    'first': 'one',
    'second': 'two',
    'third': 'three'
  };
  h.addAll({'fourth': 'four'});
  print('$h, ${h.length}, ${h['first']}'); // Keyでアクセス
  
  // ルーン文字は、文字列のUTF-32コードポイント。\uで文字を指定する
  // 絵文字の表示に使える
  Runes i = new Runes('\u2665  \u{1f605}  \u{1f60e}  \u{1f47b}  \u{1f596}  \u{1f44d}');
  print(new String.fromCharCodes(i));

  // Symbolオブジェクトは、Dartプログラムで宣言された演算子または識別子を表します。
  // コンパイル時にAPI名などは変更されてしまうが、Symbolは変更されないため、API参照などの識別に使える
  // ただし、dartライブラリなどの作成者でない限り、ほぼ使う機会はない
  // #で始まる
  #hogehoge;

  // Dartは強く型付けされていますが、Dartは型を推論できるので型注釈はオプションです。
  // 次のコードで、数値はint型であると推論されます。型が想定されていないことを明示的に示したい場合は、特殊な型dynamicを使用します。
  // any型、スクリプト言語の変数と同じような性質を持つ
  dynamic j = 10;
  j = 'a'; // dynamicだと途中で別の型のデータも格納できる
  print(j);

  // varの場合は初期化時の型推論が働くので違う型を入れようとするとエラーになる
  // var j = 0;
  // j = 'a'; // エラー

  final k = 1; // finalの変数は初期化時のみ代入可能
  // k = 2; // 再代入しようとするとエラー
  const l = 1; // 定数、再代入はエラーになる(コンパイル時に埋め込まれる)
  // l = 2;
  List m = const [1, 2, 3]; // 定数配列を代入
  // m.add(1); // 定数配列中身の変更はできない（実行時エラー：Cannot add to an unmodifiable list）
  print('$k, $l, $m');

  // finalは変数の性質で、constは変数の性質＋値の性質も規定しています（constの方が広義）
  // 例えば、次のようなfinalを使った定数値の指定はできません。
  // List l = final [1, 2, 3]; 
  // finalとconstの詳細な違いはこの記事が参考になります。
  // https://qiita.com/uehaj/items/7c07f019e05a743d1022

  // cast、別のデータ型への変換
  print(int.parse('42') == 42); // String => int
  print(double.parse('42.3') == 42.3); // String => double
  print(42.31.toString() == '42.31'); // number => String

  // forEach
  var lists = ['l', 'i', 's', 't'];
  lists.forEach((value) { print(value); });
  var sets = {'s', 'e', 't'};
  sets.forEach((value) { print(value); });
  var maps = {'k': 'm', 'e': 'a', 'y': 'p'};
  maps.forEach((key, value) { print('$key $value'); });

  // for
  for (var i = 0; i < 3; i++) {
    print(i);
  }

  // for in
  for (var i in ['f', 'o', 'r', 'i', 'n']) {
    if (i == 'o' || i == 'r') continue;
    print(i);
  }
  for (var i in {'s', 'e', 't'}) {
    print(i);
  }

  // while
  var w = 0;
  while (true) {
    if (w == 3) {
      break;
    } else if(w == 1) {
      w++;
      print('wは$w');
    } else {
      w++;
      print('w=$w');
    }
  }

  // do-while
  var dw = 0;
  do {
    dw++;
    print('dw=$dw');
  } while (dw < 3);

  // switch
  var command = 'CLOSED';
  switch (command) {
    case 'CLOSED':
      print('CLOSED');
      continue nowClosed;  // continueの場合、nowClosedラベルを実行する
    nowClosed:
    case 'NOW_CLOSED':
      print('NOW_CLOSED');
      break;
  }

  const x = 10;
  // 関数（処理のまとまりを記述する）
  // 戻り値の型を指定しない場合はdynamicになる（あまり推奨されていない）
  // 戻り値がいらない場合は戻り値にvoidを指定する
  int testFunction(){
    const y = 20;
    print('$x, $y'); // 関数の外で定義されているxは参照できる
    return x + y;
  }
  // print('$y'); // 関数の内部で定義されているyは参照できない（変数のスコープ）
  var result = testFunction();
  print('$result');

  // 一行の場合、ファットアローで省略記法がかける（JavaScriptのアロー関数と同じ）
  int oneline(a,b) => a + b;
  // この関数と等価
  // int oneline(a,b){ return a + b }
  print(oneline(1,2));

  // {}は名前付き任意引数
  void enableFlags({bool bold, bool hidden}) { print('$bold $hidden'); }
  // 引数ラベルをつけて呼び出す(記述順序は任意)
  // boldにはnull、hiddenにはtrueが渡される
  enableFlags(hidden: true);

  // []は順序付き任意引数、特定の位置以降の引数を省略可能
  // 任意引数にはデフォルト値をもたせることも可能（nullの場合、=の右辺の値が代入される）
  String say(String from, String msg, [String device = 'unknown', String mood]) {
    // ?? 演算子はnullの場合に右側の値が適応される
    return '$from says $msg platform: ${device} mood: ${mood ?? 'unknown'}';
  }
  // 第３引数以降省略可能、省略された引数はnullになる
  print(say('Bob', 'Howdy'));
  print(say('Tom', 'Howdy', 'iPhone'));

  // カスケード記法、..で対象のインスタンスに対するメソッド呼び出しの操作を続けられる
  var fullString = StringBuffer()
    ..write('Use a StringBuffer for ')
    ..writeAll(['efficient', 'string', 'creation'], ' ')
    ..toString();
  print(fullString);
  // 次と等価
  // var sb = StringBuffer();
  // sb.write('Use a StringBuffer for ');
  // sb.writeAll(['efficient', 'string', 'creation'], ' ');
  // var fullString = sb.toString();
  // print(fullString);


  // 文字列置換
  'Dart Language'.replaceAll('a', '@'); // == 'D@rt L@ngu@ge'

  var address = '東京都港区 1-1-1';
  // 正規表現でマッチするすべてを取得する
  Iterable<Match> matches = new RegExp('.?区').allMatches(address);
  for (Match m in matches) {
    print(m.group(0));
  }

  // 改行を含んだ文字列をリテラルで表現するには'''で囲う
  var sarasara = '''
改行
しました''';
  print(sarasara);

  void errorFunc() {
    try {
      // throw Exceptionで意図的に例外を投げる
      throw Exception('例外です');
    } on Exception catch(e) {
      // 捕まえる型を指定するには on ~~ catch を使う
      // eはException型
      print(e);
      // rethrowでtry-catch-finallyブロックの外に例外を投げ直す事ができる（関数の外などでcatchする必要あり）
      rethrow;
    } finally {
      // finallyブロックは例外の有無にかかわらず実行される、省略可。
      print('finally');
    }
  }

  String numbers = '1, 2, 3';
  // 文字列の分解はsplitを使う
  List numberList = numbers.split(', ');
  numberList.forEach((values) { 
    print(values);
  });

  // 例外処理：try-catch文
  try {
    errorFunc();
  } catch (e, s) {
    // 型を指定しないcatchは、何型かわからない例外全部キャッチする
    // catchに仮引数を２つ指定すると、２つ目はStackTraceオブジェクトが入る
    print(s);
  }

  // クラスのテスト
  classTest();

  // 非同期関数（async）、Future<データ型>で戻り値を返却する必要がある
  // JavaScriptのPromise関数とほぼ同じ
  Future<String> lookUpVersion() async => '1.0.0';
  var version = await lookUpVersion(); // awaitで同期待ち（async関数内でのみ使える）
  print(version);

  // 同期ジェネレータ、JavaScriptのジェネレータとほぼ同じ、Iterable<データ型>で戻り値を返却する必要がある
  // yieldの値が順次返却される
  Iterable<int> countIterator(int n) sync* {
    int k = 0;
    while (k < n) yield k++;
  }
  var iterator = countIterator(3);
  iterator.forEach((value) { print(value); });

  print('--------');

  // 非同期ジェネレータ、JavaScriptのジェネレータ、Rxのストリームに近い、Stream<データ型>で戻り値を返却する必要がある
  // yieldの値が順次返される
  Stream<int> countStream(int to) async* {
    for (int i = 1; i <= to; i++) {
      yield i;
    }
  }

  var stream = countStream(3);
  // Streamの同期待ちにはawait forを使う。yieldの結果を順次取り出すイメージ
  await for (var value in stream) {
    print(value); 
  }

  print('--------');

  var stream2 = countStream(3);
  // streamの結果を非同期で受け取るにはlistenで結果を待つ
  stream2.listen((value){
    print(value);
  });


  final receivePort = ReceivePort();
  final sendPort = receivePort.sendPort;
  // アイソレータ（スレッド処理）を実行
  await Isolate.spawn(isolate, sendPort);
  // アイソレータの結果待ち
  receivePort.listen((msg){
    print("message from another Isolate: $msg");
    exit(0); // main関数を終了する
  });
}

// スレッド処理
void isolate(sendPort) {
  for(int i = 0; i< 10; i ++) {
    print("waiting: $i");
  }
  // 呼び出し元に結果を送信する
  sendPort.send("finished!");
}


void classTest() {
  // インスタンス生成
  var person1 = new Person('Yamada', 'Taro');
  print('${person1.firstName} ${person1.lastName}');
  // メンバ関数呼び出し
  person1.greed();
  // 名前付きコンストラクタ呼び出し
  var person2 = new Person.origin();
  print('${person2.firstName} ${person2.lastName}');

  // 静的メンバはインスタンス化しなくても呼び出し可能（クラス共通の関数、変数）
  print(Person.capacity);
  Person.staticMethod();

  // callメソッドの呼び出し
  print(person1());

  // 実はprivateにアクセスできる
  person2._member = 'abc';
  print(person2._member);

  var engineer1 = new Engineer('エン', 'ジニア');
  engineer1.greed();
  // 親クラスにキャストできる
  Person engineer2 = Engineer.instance(true);
  // 呼ばれるのは継承クラスのgreed(ポリモーフィズム)
  engineer2.greed();
  // 明示的に元のクラスにキャストするにはasを使う
  (engineer2 as Engineer).greed();

  const p = Point(1, 2);
  print('x=${p.x},y=${p.y}');
  var pp = Point.alongXAxis(3);
  print('x=${pp.x},y=${pp.y}');

  var rect = Rectangle(3, 4, 20, 15);
  print('right=${rect.right}'); // rightを参照するとゲッターが呼ばれて計算結果を取得。left + width
  rect.right = 12; // rightを変えるとセッターがよばれて
  print('left=${rect.left}'); // leftの結果も変わる

  var v1 = new Vector(1, 2);
  var v2 = new Vector(2, 3);
  var v3 = v1 + v2;
  print('x=${v3.x},y=${v3.y}');

  // abstractクラスはインスタンス化できない
  // var animal = new Animal();
  var cat = new Cat();
  cat.hello();

  // Masterクラスのインスタンスを作成
  var master = new Master('Master');
  print(master.commit('ToDo List'));
  // Masterインタフェースを継承したBranchクラスのインスタンスを作成
  var branch = new Branch();
  print(branch.commit('sort'));

  var director = Director('Tanaka', 'Saburo');
  director.hello();
  director.story();

  var c = Color.blue;
  print(Color.green.index == 1);
  // 列挙型はswitchの条件分岐に使える
  switch (c) {
    case Color.green:
      print('green');
      break;
    case Color.blue:
      print('blue');
      break;
    case Color.red:
      print('red');
      break;
    default:
  }

  // mixin
  var musician = new Musician();
  // Performerクラスの実装を呼び出す
  musician.PerformerMethod();
  // Musicalクラスの実装を呼び出す
  musician.MusicalMethod();

  // ジェネリックスのインスタンス化は型を指定する
  var cache = new Cache<String>();
  cache.setByKey('key', 'test');
  print('key=${cache.getByKey('key')}');

  // メソッドのジェネリックス
  // 型の制限をするときは型のextendsを使う
  T sum<T extends num>(List<T> list, T init){
    T sum = init;
    list.forEach((value) { 
      sum += value;
    });
    return sum;
  }

  int r1 = sum([1,2,3], 0);
  print(r1);
  double r2 = sum([1.1, 2.2, 3.3], 0.0);
  print(r2);

  // sort関数をtypedefで定義した型で格納
  Compare<int> sortFunc = sort;
  print('sort: ${sortFunc(1, 2)}');
}

class Person {
  String firstName;
  String lastName;

  // this.フィールド名の引数だけで、フィールドに値を代入できる
  // コンストラクタのブロック内ではすでに代入された状態で使用できる
  // thisを省略すると別の仮引数として扱われてしまう
  Person(this.firstName, this.lastName);

  // privateメンバは便宜上、_から始まる。ただし、アクセスしようと思えばアクセスできてしまう。
  String _member;

  // 名前付きコンストラクタ
  // 複数のコンストラクタをもたせたいときに使う
  Person.origin() {
    this.firstName = '氏';
    this.lastName = '名';
    // 実はメソッド内はthisを省略してもクラス内のフィールドにアクセスできる
    // firstName = '氏';
    // lastName = '名';
  }

  // メンバ関数（インスタンス化したら呼び出し可能）
  greed() {
    print('Hello ${firstName} ${lastName}');
  }

  // 同名メソッドは作成できない（メソッドのオーバーロード）
  // 引数で処理を分けたい同名メソッドを作りたければ任意引数を使う
  // greed(int a) {}

  // 静的メンバ変数
  static const capacity = 16;

  // 静的メンバ関数
  static void staticMethod() {
    print('Hello');
  }

  // callは特殊なメソッド
  // インスタンス名()で呼び出しできる(呼び出し可能なクラス)
  call() => '$firstName $lastName';
}

// extendsでクラスの継承（親クラスのメンバが参照できる）
class Engineer extends Person {
  final String name;

  // 親クラスのコンストラクタを呼ぶには初期化子（:）でsuperを使う
  // メンバ変数の初期化も初期化子内で行える
  Engineer(String firstName, String lastName) : 
    name = '', 
    super(firstName, lastName);

  Engineer.origin():
    name = 'hello',
    super.origin() {
    print('${firstName} ${lastName}');
  }

  // 先頭にfactoryキーワードをつけるとファクトリーコンストラクタとなる
  // 自身のインスタンスを戻り値として返すことを明示できる
  factory Engineer.instance(bool isEngineer) {
    var instance = isEngineer ? new Engineer.origin() : new Person.origin();
    return instance;
  }

  // メソッドの上書き
  // @overrideは任意（けど書いたほうがわかりやすい）
  @override
  greed() {
    // super.greed(); // メンバ関数内でコンストラクタ以外の親クラスのメンバ関数はsuper.メンバ関数名で呼び出しできる
    print('I am ${firstName}${lastName}');
  }
}

class Point {
  final int x;
  final int y;

  // 不変コンストラクタ
  // フィールドが全部 final 宣言されていると、コンストラクタの頭にconstをつけられる
  // この場合、インスタンスされた変数はコンパイル定数として扱われる
  const Point(this.x, this.y);

  // リダイレクトコンストラクタ
  // 別のコンストラクタに一部処理を移譲する
  const Point.alongXAxis(int x): this(x, 0);
}

class Rectangle {
  int left, top, width, height;

  Rectangle(this.left, this.top, this.width, this.height);

  // ゲッター：rightのパラメータを参照できる。（実態はleft+widthの計算結果を返す）
  int get right => left + width;
  // セッター：パラメータを代入時にleftを計算する
  set right(num value) => left = value - width;
  int get bottom => top + height;
  set bottom(num value) => top = value - height;
}

class Vector {
  final int x, y;

  Vector(this.x, this.y);

  // 演算子のオーバーライド（演算子の振る舞いをメソッドの処理に上書きする）
  // C++の演算子のオーバーライドと同じ
  // この例はベクトルの足し算、引き算を定義できる
  // 強力な反面、不用意に使うと混乱を招くのでベクトルや行列計算等の数学的な処理を定義する以外はあまり使わないほうが良い
  Vector operator +(Vector v) => Vector(x + v.x, y + v.y); // Vector + Vector
  Vector operator -(Vector v) => Vector(x - v.x, y - v.y); // Vector - Vector
}

// 抽象クラス
// 処理未定義のメンバ関数を持つクラス、インスタンス化できない
abstract class Animal {
  void hello();
}

// 抽象クラスを継承して未定義メンバ関数を実装する
class Cat extends Animal {
  void hello() {
    print("みゃお");
  }
}

// Dartには interfaceキーワードが存在しませんが、クラスを宣言した時点でそのクラスと同じAPIのinterfaceが勝手に作られる（暗黙的なinterface）
// インターフェイスは実装を持たない
// Masterクラスの宣言であり、commit()メソッドを持ったMasterインターフェイスの宣言でもある
class Master {
  // privateなものはインターフェイスには含まれない
  final _name;

  // コンストラクタもインターフェイスには含まれない
  Master(this._name);

  String commit(String msg) => '${_name} commit ${msg}';
  // このメンバ関数の宣言のみインターフェイスに含まれる（実装は含まれない）
  // String commit(String msg);
}

// implementsでPersonインターフェイスを実装する
class Branch implements Master {
  // privateメンバ変数に関してはゲッターの実装をしないと怒られる
  get _name => '';

  // greetを実装しないと怒られる
  String commit(String msg) => 'Branch commit ${msg}';
}

// extendsの親クラスは１つしか指定できないのに対し、implementsは複数指定できる（Javaと一緒）
// 抽象クラスもimplementsできる
class Director extends Person implements Animal, Point {
  // Personのコンストラクタを継承
  Director(String firstName, String lastName) : super(firstName, lastName);

  // Animalのメンバ関数
  @override
  void hello() {
    print('I am Director');
  }

  // Pointのゲッター実装
  @override
  int get x => x;

  // Pointのゲッター実装
  @override
  int get y => y;

  // Director独自のメンバ関数
  void story() {
    print('Yes we can');
  }
}


class Performer {
  Performer() {
    print('Perfomer');
  }
  void PerformerMethod() {
    print('PerformerMethod');
  }
}
class Musical {
  // mixinに使う場合はコンストラクタが定義できない
  // Musical() {
  //   print('Musical');
  // }
  void MusicalMethod() {
    print('MusicalMethod');
  }
}

// ミックスイン、with句でつないだクラスの実装が使える
// 多重継承に似ているが、コンストラクタが定義できるのはextendsしたクラスのみ
class Musician extends Performer with Musical {
  Musician(): super() {
    print('Musician');
  }
}


// 列挙型
// 列挙子は宣言された順にインデックス（0始まり）が割り振られていて、 index で参照できる。
// enumを継承できなかったり（mixinにも使えない）、enumのインスタンスを自前で生成できない（定数のみしか使えない）
// 実装を持つことが出来ない以外、Javaとほぼ同じ
enum Color { red, green, blue }

// 型だけが違う実装をしたクラスを実装したい場合はジェネリックスを使うと便利
// インスタンス化するときTに型を指定する
class Cache<T> {
  Map<String, T> store = <String, T>{};

  T getByKey(String key) {
    return store[key];
  }

  void setByKey(String key, T value) {
    this.store.addAll(<String, T>{key: value});
  }
}


// typedefで関数の別名（型）を定義できる
typedef Compare<T> = T Function(T a, T b);
int sort(int a, int b) => a - b;
