void crtajOpcije()
{
  //background(0);
  //image(pozadina, width/2, height/2/*, width, height*/);
  textSize(width/40);
  fill(50,124,0);
  text("Neke opcije, ispod gumb za povratak.",width/2,height/3);
  
  //gumb za povratak
  rectMode(CENTER);
  fill(20, 86, 20);
  rect(width/2, 6*height/7, width/2, height/6);
  fill(0);
  text("Klikni za povratak.", width/2, 6*height/7);
}