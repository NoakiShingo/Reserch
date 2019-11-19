//percentに応じた円の描画をする
void addCircle() {
  for (int row = 0; row < menu_count; row++) {
    String abbrev = foods[row].name;
    float x = coordinate[row][0];
    float y = coordinate[row][1];
    float value = foods[row].hit_count;
    
    fill(255);
    stroke(255);
    ellipse(P[row], Q[row], D[row], D[row]); //これないと円の中に線引かれる

    if (percent[row] >=1.0) {
      stroke(Red[row], 69, Blue[row], 255);
      imageMode(CENTER);
      image(foods[row].photo, P[row]-3.25, Q[row], D[row]+D[row]*1.5, D[row]+D[row]);
      fill(0);
      textAlign(CENTER);
      text(abbrev, P[row], Q[row]-D[row]-6);
      if (dist(x, y, mouseX, mouseY)<D[row]+2) {
        cursor = row;
        D[row] = D[row] * 1.1;
        image(foods[row].photo, P[row]-3.25, Q[row], D[row]+D[row]*1.7, D[row]+D[row]);
      }
    } else if (percent[row] >=0.83) {
      stroke(Red[row], 69, Blue[row], 225);
      imageMode(CENTER);
      image(foods[row].photo, P[row]-2.6, Q[row], D[row]+D[row]*1.5, D[row]+D[row]);
      fill(0);
      textAlign(CENTER);
      text(abbrev, P[row], Q[row]-D[row]-6);
      if (dist(x, y, mouseX, mouseY)<D[row]+2) {
        cursor = row;
        D[row] = D[row] * 1.15;
        image(foods[row].photo, P[row]-2.6, Q[row], D[row]+D[row]*1.6, D[row]+D[row]);
      }
    } else if (percent[row] >=0.67) {
      stroke(Red[row], 69, Blue[row], 195);
      imageMode(CENTER);
      image(foods[row].photo, P[row]-2, Q[row], D[row]+D[row]*1.5, D[row]+D[row]);
      fill(0);
      textAlign(CENTER);
      text(abbrev, P[row], Q[row]-D[row]-6);
      if (dist(x, y, mouseX, mouseY)<D[row]+2) {
        cursor = row;
        D[row] = D[row] * 1.15;
        image(foods[row].photo, P[row]-2, Q[row], D[row]+D[row]*1.6, D[row]+D[row]);
      }
    } else if (percent[row] >= 0.5) {
      stroke(Red[row], 69, Blue[row], 165);
      imageMode(CENTER);
      image(foods[row].photo, P[row]-2, Q[row], D[row]+D[row]*1.5, D[row]+D[row]);
      fill(0);
      textAlign(CENTER);
      text(abbrev, P[row], Q[row]-D[row]-6);
      if (dist(x, y, mouseX, mouseY)<D[row]+2) {
        cursor = row;
        D[row] = D[row] * 1.2;
        image(foods[row].photo, P[row]-2, Q[row], D[row]+D[row]*1.6, D[row]+D[row]);
      }
    } else if (percent[row] >=0.34) {
      stroke(Red[row], 69, Blue[row], 135);
      fill(0);
      textAlign(CENTER);
      text(abbrev, P[row], Q[row]-D[row]-6);
      if (dist(x, y, mouseX, mouseY)<D[row]+2) {
        D[row] = D[row] * 1.2;
        cursor = row;
      }
    } else if (percent[row] >=0.20) {
      stroke(Red[row], 69, Blue[row], 105);
      fill(0);
      textAlign(CENTER);
      text(abbrev, P[row], Q[row]-D[row]-6);
      if (dist(x, y, mouseX, mouseY)<D[row]+2) {
        D[row] = D[row] * 1.2;
        cursor = row;
      }
    } else if (percent[row] >=0.01) {
      stroke(Red[row], 69, Blue[row], 75);
      if (dist(x, y, mouseX, mouseY)<D[row]+2) {
        fill(0);
        textAlign(CENTER);
        text(abbrev, P[row], Q[row]-D[row]-6);
        D[row] = D[row]*1.25;
        cursor = row;
      }
    } else if (percent[row] ==0) {
      stroke(Red[row], 69, Blue[row], 45);
      if (dist(x, y, mouseX, mouseY)<D[row]+2) {
        fill(0);
        textAlign(CENTER);
        text(abbrev, P[row], Q[row]-D[row]-6);
        D[row] = D[row]*1.25;
        cursor = row;
      }
    }

    strokeWeight(2);
    noFill();
    ellipseMode(RADIUS);
    ellipse(P[row], Q[row], D[row], D[row]);
    if (row == number){
      ellipse(P[row], Q[row], D[row]*1.05, D[row]*1.08);
    }
  }
}

void addLine(){
  for (int i=0; i<menu_count; i++){
    for (int j=0; j<menu_count; j++){
      if (i==j){
        continue;
      }
      if (CulcResult[i][j] >= 0.8){
        if (PercentResultC[i][j] == 11){
          stroke(255,69,0,line.L11);
        } else if (PercentResultC[i][j] ==10){
          stroke(100,0,100,line.L10);
        } else if (PercentResultC[i][j] ==9){
          stroke(0,69,255,line.L9);
        }
        strokeWeight(PercentResultW[i][j]);
        if ( cursor == i || cursor == j){
          strokeWeight(PercentResultW[i][j]*3);
        }
        line(P[i], Q[i], P[j], Q[j]); 
      }
    }
  }
}
