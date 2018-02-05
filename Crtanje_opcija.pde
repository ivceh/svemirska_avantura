void crtajOpcije()
{
  background(0);
  textSize(width/40);
  fill(50,124,0);
  text("Neke opcije, ispod gumb za povratak.",width/2,height/3);
  
  rectMode(CENTER);
  fill(200,0,100);
  rect(width/2,4*height/6,2*width/3, height/3);
  fill(0);
  text("Klikni za povratak.",width/2,4*height/6);
}