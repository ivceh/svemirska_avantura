int velicinaNaslova = 1;

PFont izbornikNaslovFont;

void crtajIzbornik()
{
  if(velicinaNaslova < height/10)
  {
    velicinaNaslova+=1;
  }
  
  //boja se ne mijenja svaki put, nego svaki 10. put (da ne bude prebrzo)
  if(frameCount%10==0) 
  {
    fill((int)random(255),(int)random(255),(int)random(255));
  }
  
  textSize(velicinaNaslova);
  //zakomentirano radi performansi
  //image(pozadina, width/2, height/2/*, width, height*/);
  text("SVEMIRSKA AVANTURA", width/2, height/5);
  
  image(mars, width*0.2,height*0.45);
  image(venera, width*0.6,height*0.45);
  image(neptun, width*0.4,height*0.75);
  image(pluton, width*0.8,height*0.75);
}