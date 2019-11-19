//hit_countから円の大きさを決める
//ここでpercent求めてる
void diameter() {
  for (int i=0; i<menu_count; i++) {
    float value = foods[i].hit_count;
    diameter[i] = map(value, dataMin, dataMax, 5, 25);
    percent[i] = norm(value, dataMin, dataMax);
    if (percent[i] >= 0.5){
      Red2[i] = 255;
      Blue2[i] = 0;
    } else if (percent[i] < 0.5){
      Red2[i] = 0;
      Blue2[i] = 255;
    }
  }
}

//最初だけはこっちのdiameterを使用する
void diameter_start() {
  for (int i=0; i<menu_count; i++) {
    float value = foods[i].hit_count;
    diameter[i] = map(value, dataMin, dataMax, 5, 25);
    percent[i] = norm(value, dataMin, dataMax);
    if (percent[i] >= 0.5){
      Red2[i] = 255;
      Blue2[i] = 0;
      Red[i] = 255;
      Blue[i] = 0;
    } else if (percent[i] < 0.5){
      Red2[i] = 0;
      Blue2[i] = 255;
      Red[i] = 0;
      Blue[i] = 255;
    }
  }
}

//重ならないような円の配置を決める
void randomCircle() {
  int i = 0;
  circles = new ArrayList<PVector>();

  while (circles.size() < menu_count) {
    float rx = random(startX, width-25);
    float ry = random(25, height-25);
    PVector c = new PVector(rx, ry, diameter[i]);
    boolean overlapping = false;
    boolean distlapping = false;
    boolean centerlapping = false;
    boolean distinction = false;

    for (PVector p : circles) {
      if (percent[i] >= 0.5) {
        //各円が重ならない
        if (dist(c.x, c.y, p.x, p.y) < (c.z + p.z + 50)) {
          overlapping = true;
          break;
        }
        //円が画面外に表示されない
        if (dist(c.x, c.y, mannaka, 400) > 245) {
          distlapping = true;
          break;
        }
        //中心に重ならない
        if (dist(c.x, c.y, mannaka, 400) < (c.z + 65)) {
          centerlapping = true;
          break;
        }
      } else if (percent[i] < 0.5) {
        //各円が重ならない
        if (dist(c.x, c.y, p.x, p.y) < (c.z + p.z + 50)) {
          overlapping = true;
          break;
        }
        //円が画面外に表示されない
        if (dist(c.x, c.y, mannaka, 400) > 365) {
          distlapping = true;
          break;
        }
        //中心に重ならない
        if (dist(c.x, c.y, mannaka, 400) < (c.z + 60)) {
          centerlapping = true;
          break;
        }
        if (dist(c.x, c.y, mannaka, 400) < 270) {
          distinction = true;
          break;
        }
      }
    }
    if (percent[i] >= 0.5) {
      if (!overlapping && !distlapping && !centerlapping) {
        //配列の要素を追加
        circles.add(c);
        coordinate[i][0] = rx;
        coordinate[i][1] = ry;
        i++;
      }
    } else if (percent[i] < 0.5) {
      if (!overlapping && !distlapping && !centerlapping && !distinction) {
        //配列の要素を追加
        circles.add(c);
        coordinate[i][0] = rx;
        coordinate[i][1] = ry;
        i++;
      }
    }
  }
  coordinate[number][0] = mannaka;
  coordinate[number][1] = 400;
}
