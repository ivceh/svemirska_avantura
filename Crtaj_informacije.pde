void crtajInformacije()
{
  background(0);
  textSize(width/40);
  fill(0,0,255); //plavo
  text("Neke info, ispod gumb za povratak.",width/2,height/3);
  
  rectMode(CENTER);
  fill(255,0,0); //crvena boja
  rect(width/2,4*height/6,2*width/3, height/3);
  fill(0);
  text("Klikni za povratak.",width/2,4*height/6);

  if(mousePressed)
  {
    if(mouseX > width/6 && mouseX < 5*width/6 && mouseY < 5*height/6 && mouseY > height/2)
      stanjeIzbornika = 0;
  }
}