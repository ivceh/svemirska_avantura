void crtajInformacije()
{
  //pozadine zakomentirane zbog performansi
  //background(0);
  //image(pozadina, width/2, height/2/*, width, height*/);
  textSize(width/40);
  fill(0,0,255); //plavo
  text("Neke info, ispod gumb za povratak.",width/2,height/3);
  
  //gumb za povratak
  rectMode(CENTER);
  fill(255,0,0); //crvena boja);
  rect(width/2, 6*height/7, width/2, height/6);
  fill(0);
  text("Klikni za povratak.", width/2, 6*height/7);
}