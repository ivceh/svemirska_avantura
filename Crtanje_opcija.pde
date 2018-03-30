boolean glazbaUkljucena = true;

void crtajOpcije()
{
  rectMode(CENTER);

  String tekstGumba = "";

  //gumb za uključi/isključi glazbu
  if (glazbaUkljucena == true) { 
    //za isključivanje glazbe
    fill(255, 0, 0);
    tekstGumba = "Glazba - ON";
  } else {
    //za uključivanje glazbe
    fill(0, 0, 255);
    tekstGumba = "Glazba - OFF";
  }
  rect(width/2, height/6+height/12, 11*width/12, height/6);
  textSize((width/20<height/10) ? width/20 : height/10);
  fill(255); //bijeli tekst
  text(tekstGumba, width/2, height/6+height/7);
  
  //gumb za povratak
  textSize(width/40);
  fill(20, 86, 20);
  rect(width/2, 6*height/7, width/2, height/6);
  fill(0);
  text("Klikni za povratak.", width/2, 6*height/7);
}