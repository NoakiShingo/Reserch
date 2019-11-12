//料理ごとに使われている食材のhit_countを求める
void count(int k) {
  String target;
  int flag;
  //println(foods[k].guzai.length);

  //母体の食べ物に含まれる具材をいくつ含んでいるかをhit_countに
  for (int i=0; i<foods[k].guzai.length; i++) {
    target = foods[k].guzai[i];
    //println(target);
    flag = 0;
    for (int m=0; m<menu_count; m++) {
      for (int n=0; n<foods[m].guzai.length; n++) {
        String guzai = foods[m].guzai[n];
        int p = guzai.indexOf(target);
        if (p>=0) {
          flag++;
          foods[m].hit_count++;
        }
      }
      //println(foods[m].name + ":" + foods[m].hit_count);
    }
  }
  //処理終わり

  //hit_countの最大・最小を決める
  for (int i=0; i<foods.length; i++) {
    float value = foods[i].hit_count;
    if (value > dataMax) {
      dataMax = value;
    }
    if (value < dataMin) {
      dataMin = value;
    }
  }
  //println(dataMax);
  //println(dataMin);
  //処理終わり
}


//料理ごとに使われている動作のhit_countを求める
void d_count(int k) {
  String target;
  int flag;

  //母体の食べ物に含まれる動作をいくつ含んでいるかをhit_countに
  for (int i=0; i<foods[k].dousa.length; i++) {
    target = foods[k].dousa[i];
    flag = 0;
    for (int m=0; m<menu_count; m++) {
      for (int n=0; n<foods[m].dousa.length; n++) {
        String dousa = foods[m].dousa[n];
        int p = dousa.indexOf(target);
        if (p>=0) {
          flag++;
          foods[m].hit_count++;
        }
      }
    }
  }
  //処理終わり

  //hit_countの最大・最小を決める
  for (int i=0; i<foods.length; i++) {
    float value = foods[i].hit_count;
    if (value > dataMax) {
      dataMax = value;
    }
    if (value < dataMin) {
      dataMin = value;
    }
  }
}


void culcResults() {
  for (int i=0; i<menu_count; i++) {
    count(i);
    dataMin = MAX_FLOAT;
    dataMax = MIN_FLOAT;
    for (int m = 0; m < menu_count; m++) {
      float value = foods[m].hit_count;
      if (value > dataMax) {
        dataMax = value;
      }
      if (value < dataMin) {
        dataMin = value;
      }
    }
    for (int j=0; j<menu_count; j++) {
      float value = foods[j].hit_count;
      float percent = norm(value, dataMin, dataMax);
      CulcResult[i][j] = percent;
      foods[j].hit_count = 0;
    }
  }
}