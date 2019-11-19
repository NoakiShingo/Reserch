import controlP5.*;
import de.bezier.data.*;
ControlP5 cp5;
Accordion accordion;
XlsReader reader;
int menu_count;//Xlsファイルの料理の数
Food [] foods = new Food [30]; //ここの数だけはexcelファイルの中身変えたときにチェックする
Line line;
int guru = 0;
int number = 0; //検索する料理の番号
float dataMin = MAX_FLOAT;
float dataMax = MIN_FLOAT;
float [][] coordinate; //円の中心座標
float [][] Bcoordinate; //前の円の中心座標
float [] diameter; //円の半径
float [] Bdiameter; //前の円の半径
float [] aD; //円の半径拡大の速さ
float [] D; 
float [] Q; //移動中のy座標
float [] P; //移動中のx座標
float [] U; //if文をぶん回す用の変数
float [] V;
float [] a; //傾き
float [] b; //x=0との接点座標
float [] percent; 
float [] Red;
float [] BRed;
float [] Blue;
float [] Red2;
float [] Blue2;
float [][] CulcResult; //食べ物同士の関連度の計算結果を保存
color [][] PercentResultC; //percentに応じて線の色を変化
float [][] PercentResultW; //percentに応じて線の太さを変化
ArrayList <PVector> circles;
int gamenX = 1000;
int startX = gamenX - 800 + 25;
int mannaka = gamenX - 400;
int cursor;

void setup() {
  size(1000, 800);
  gui();
  background(255);
  PFont font = createFont("PFont", 10, true);
  textFont(font);

  reader = new XlsReader( this, "recipe4.xls" ); //ファイル名を指定して読み込む（Excelシートはdataフォルダの中に入れる）
  reader.firstRow(); //最初の行に移動する（データが入っていない行は無視する）そして最初のセルを選ぶ
  menu_count = reader.getInt(); //データを読み込む

  line = new Line();
  coordinate = new float[menu_count][2];
  Bcoordinate = new float[menu_count][2];
  diameter = new float[menu_count];
  Bdiameter = new float[menu_count];
  aD = new float[menu_count];
  D = new float[menu_count];
  percent = new float[menu_count];
  Q = new float[menu_count];
  P = new float[menu_count];
  a = new float[menu_count];
  b = new float[menu_count];
  U = new float[menu_count];
  V = new float[menu_count];
  Red = new float[menu_count];
  BRed = new float[menu_count];
  Red2 = new float[menu_count];
  Blue = new float[menu_count];
  Blue2 = new float[menu_count];
  CulcResult = new float[menu_count][menu_count];
  PercentResultC = new color[menu_count][menu_count];
  PercentResultW = new float[menu_count][menu_count];

  for (int i=0; i<menu_count; i++) {
    foods[i] = new Food();
    V[i] = 1;
    BRed[i] = 0;
  }

  for (int i=0; i<menu_count; i++) {
    reader.nextRow();
    String menu = reader.getString(); //料理名取得s
    foods[i].name = menu;

    reader.nextCell();
    String item_url = reader.getString();
    foods[i].photo_url = item_url;

    //材料がいくつ入っているかを取得し、その数だけfor分を回す
    //動作編
    reader.nextCell();
    int move_items_count = reader.getInt();

    ArrayList<String> list_move = new ArrayList<String>();
    for (int j=0; j<move_items_count; j++) {
      reader.nextCell();
      String move = reader.getString();
      list_move.add(move);
    }
    String[] dousa = list_move.toArray(new String[list_move.size()]);
    foods[i].dousa = dousa;

    //食材編
    reader.nextCell();
    int material_items_count = reader.getInt();

    ArrayList<String> list_item = new ArrayList<String>();
    for (int j=0; j<material_items_count; j++) {
      reader.nextCell();
      String item = reader.getString();
      list_item.add(item);
    }
    String[] item = list_item.toArray(new String[list_item.size()]);
    foods[i].guzai = item;

    guru++;
  }

  for (int i=0; i<menu_count; i++) {
    foods[i].photo = loadImage(foods[i].photo_url);
    //println(foods[i].photo);
  }
  
  culcResults();
  count(0);
  diameter_start();
  percentResults();
  randomCircle();
  move_setting();
  for (int i=0; i<1200; i++) {
    move();
    Line_colorchange();
  }
  addCircle();
}

void draw() {
  background(255);
  move();
  addLine();
  cursor = 100; //これここじゃないとダメ
  addCircle();
  colorchange();
  Line_colorchange();
}

void mousePressed() {
  float x;
  float y;
  int Bnumber = number; //クリック前のnumberを保存しておくようの変数

  //クリックされた料理を中心にしてcountをし直すための処理
  for (int row = 0; row < menu_count; row++) {
    foods[row].hit_count = 0;
    x = P[row];
    y = Q[row];
    if (dist(x, y, mouseX, mouseY) < diameter[row]+2) {
      for (int i=0; i<menu_count; i++) {
        Bcoordinate[i][0] = coordinate[i][0];
        Bcoordinate[i][1] = coordinate[i][1];
        Bdiameter[i] = diameter[i];
        BRed[i] = Red2[i];
      }
      number = row;
    }
  } 

  for (int row = 0; row < menu_count; row++) {
    if (dist(coordinate[row][0], coordinate[row][1], mouseX, mouseY) < diameter[row]+2) {
      dataMin = MAX_FLOAT;
      dataMax = MIN_FLOAT;
      count(number);
      diameter();
      line.L11 = 0;
      line.L10 = 0;
      line.L9 = 0;
      percentResults();
      randomCircle();
      move_setting();
      //処理終わり
      for (int i=0; i<menu_count; i++) {
        V[i] = abs(coordinate[i][0] - Bcoordinate[i][0]) / 100;
      }
    }
  }
}

//円を動かすようの関数
void move() {
  for (int i=0; i<menu_count; i++) {
    if (coordinate[i][0]-Bcoordinate[i][0] >=0) {
      if (U[i] < coordinate[i][0]-Bcoordinate[i][0]) {
        P[i] = Bcoordinate[i][0] + U[i];
        Q[i] = a[i] * (Bcoordinate[i][0] + U[i]) + b[i];
        U[i] += V[i];
      }
    } else if (coordinate[i][0]-Bcoordinate[i][0] < 0) {
      if (U[i] < Bcoordinate[i][0]-coordinate[i][0]) {
        P[i] = Bcoordinate[i][0] - U[i];
        Q[i] = a[i] * (Bcoordinate[i][0] - U[i]) + b[i];
        U[i] += V[i];
      }
    }
    if (diameter[i]-Bdiameter[i] >= 0) {
      D[i] = Bdiameter[i] + aD[i] * U[i];
    } else if (diameter[i]-Bdiameter[i] < 0) {
      D[i] = Bdiameter[i] - aD[i] * U[i];
    }
  }
}

void move_setting() {
  for (int i=0; i<menu_count; i++) {
    U[i] = 0;
    aD[i] = abs(diameter[i] - Bdiameter[i])/abs(coordinate[i][0] - Bcoordinate[i][0]);
    a[i] = (coordinate[i][1] - Bcoordinate[i][1])/(coordinate[i][0] - Bcoordinate[i][0]);
    b[i] = Bcoordinate[i][1] - a[i] * Bcoordinate[i][0];
  }
}

//円の色を次第に変化させるための関数
void colorchange() {
  for (int i=0; i<menu_count; i++) {
    if (BRed[i] == 255 && Red2[i] == 0) {
      if (Red[i] > 2) {
        Red[i] -= 2.5;
      }
      if (Blue[i] < 253) {
        Blue[i] += 2.5;
      }
    } else if (BRed[i] == 0 && Red2[i] == 255) {
      if (Red[i] < 253) {
        Red[i] += 2.5;
      }
      if (Blue[i] > 2) {
        Blue[i] -= 2.5;
      }
    }
  }
}

void Line_colorchange(){
  if (line.L11 <= 110){
    line.L11 += 1.1;
  }
  if (line.L10 <= 100){
    line.L10 += 1.0;
  }
  if (line.L9 <= 90){
    line.L9 += 0.9;
  }
}

void gui(){
  cp5 = new ControlP5(this);
  
  Group g3 = cp5.addGroup("Controller")
    .setBackgroundColor(color(0,64))
    .setBackgroundHeight(200);
    
  cp5.addSlider("alpha")
    .setPosition(20, 10)
    .setSize(140, 40)
    .setRange(5, 30)
    .setValue(10)
    .moveTo(g3)
    ;
    
  cp5.addSlider("beta")
    .setPosition(20, 70)
    .setSize(140, 40)
    .setRange(5, 30)
    .setValue(20)
    .moveTo(g3)
    ;
    
  cp5.addSlider("gammma")
    .setPosition(20, 130)
    .setSize(140, 40)
    .setRange(1, 10)
    .setValue(8)
    .moveTo(g3)
    ;

  accordion = cp5.addAccordion("acc").setPosition(10, 20).setWidth(200).addItem(g3);
  accordion.open(0, 1, 2);
  accordion.setCollapseMode(Accordion.MULTI);
}
