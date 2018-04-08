int brojIgreZaPrikaz; // 0-2
String[] imenaIgara=new String[3];
String[] opisiIgara=new String[3];
PImage[] slikeIgara=new PImage[3];
String[] imenaAutora=new String[3];
PImage strelicaDesno, strelicaLijevo;
PImage strelicaDesnoFilter, strelicaLijevoFilter;
boolean refreshHighScore=true;      //popis Highscoreova refreshamo samo pri uctavanju menija...varijabla se postavi na false nakon dohvacanja , a vraca na true kod izlaza iz menija.

void crtajInformacije()
{
  if(refreshHighScore){
    dohvatiHighscores();
    refreshHighScore=false;
  }
  textFont(createFont("MONO.ttf",32));
  textSize(width/50);
  textAlign(LEFT,TOP);
  fill(255,255,255); //plavo
  text("Igra "+(brojIgreZaPrikaz+1)+". :"+imenaIgara[brojIgreZaPrikaz],width/20,height/10);
  
  //textAlign(RIGHT,TOP);
  text("AUTOR: "+imenaAutora[brojIgreZaPrikaz],width/2,height/10);
  
  int razmakIzmeduBoxova=width/48;
  
  //ScreenShot:
  rectMode(CENTER);
  image(slikeIgara[brojIgreZaPrikaz],razmakIzmeduBoxova + width/6 , height/2);
  
  //box s opisom igre
  int sirinaBoxa=width/3;
  int visinaBoxa=height/2;
  int polozajBoxaX=2*razmakIzmeduBoxova+ width/3 + width/6;
  int polozajBoxaY=height/2;
  //Upute:
  rectMode(CENTER);
  fill(0, 0, 153);
  rect(polozajBoxaX, polozajBoxaY, sirinaBoxa,visinaBoxa);
  fill(255);
  text(opisiIgara[brojIgreZaPrikaz], polozajBoxaX, polozajBoxaY, sirinaBoxa*8/9, visinaBoxa*8/9);
  
  
  //box za highscore
  rectMode(CENTER);
  fill(0, 0, 153);
  rect(3*razmakIzmeduBoxova+ 2*width/3+width/4/2, polozajBoxaY, width/4,visinaBoxa);
  fill(255);
  text("Highscore:", 3*razmakIzmeduBoxova+ 2*width/3+width/4/2, polozajBoxaY, (width/4)*8/9, visinaBoxa*8/9);
  textSize(width/50);
  for(int i=0;i<10;i++){
    textAlign(LEFT);
    fill(255);
    text(TopPlayers[brojIgreZaPrikaz*10+i],3*razmakIzmeduBoxova+ 2*width/3+width/4/2, polozajBoxaY+(i+2)*width/50,(width/4)*8/9,visinaBoxa*8/9);
    textAlign(RIGHT);
    fill(204, 51, 0);
    text(str(HighScores[brojIgreZaPrikaz*10+i]),3*razmakIzmeduBoxova+ 2*width/3+width/4/2, polozajBoxaY+(i+2)*width/50,(width/4)*8/9,visinaBoxa*8/9);

  }
  
  
 
  
  //Strelice
  //rectMode(CENTER);
  if((pow(mouseX-21*width/24, 2)+pow(mouseY-6*height/7, 2)) < pow(height/12,2))
    image(strelicaDesno,21*width/24, 6*height/7);
  else
    image(strelicaDesnoFilter,21*width/24, 6*height/7);

  if((pow(mouseX-width/8, 2)+pow(mouseY-6*height/7, 2)) < pow(height/12,2))
    image(strelicaLijevo,width/8, 6*height/7);
  else
    image(strelicaLijevoFilter,width/8, 6*height/7);

  
  
  
  
  
  //gumb za povratak
  textFont(izbornikNaslovFont);
  textSize(width/40);
  textAlign(CENTER);
  //gumb za povratak
  rectMode(CENTER);
  fill(255,0,0); //crvena boja);
  rect(width/2, 6*height/7, width/2, height/6);
  fill(0);
  text("Klikni za povratak.", width/2, 6*height/7);
}


void ucitajInfoMeni(){
  for(int i=0;i<3;i++){
    slikeIgara[i] = loadImage("Game"+str(i+1)+".png");    
    slikeIgara[i].resize(width/2, height/10); 
  }
  brojIgreZaPrikaz=0;

}

void ucitajPodatkeZaInfoMenu(){

  brojIgreZaPrikaz=0;
  imenaAutora[0]="Maja Marija Barukcic";
  imenaAutora[1]="Ivan Ceh";
  imenaAutora[2]="Sebastijan Horvat";
  
  imenaIgara[0]="Star Hunter";
  imenaIgara[1]="SpaceMen";
  imenaIgara[2]="SpaceWars";
  
   opisiIgara[0]="Izbjegavaj meteorite na svom putu do zvijezda. Ne zaboravi da je svemir na tvojoj strani i salje ti razlicite boostere. ";
   opisiIgara[1]="Treba pomoci svemirskom brodu da sakupi sve meteore. Ali tu je NLO i zli svemirci koji zele unistiti svemirski brod. ";
   opisiIgara[2]="Zli izvanzemljaci okupili su smrtonosnu flotu (i nekoliko tenkova). Pomozi nasem junaku (u njegovom svemirskom brodu) sve ih unistiti! ";

   for(int i=0;i<3;i++)
   {
     slikeIgara[i]=loadImage("Game"+(i+1)+".png");  
     slikeIgara[i].resize(width/3, height/2);
   }


   
      
   strelicaDesno=loadImage("desno.png");
   strelicaDesno.resize(height/6,height/6);
   strelicaLijevo=loadImage("lijevo.png");
   strelicaLijevo.resize(height/6,height/6);
   
   strelicaDesnoFilter=loadImage("desno.png");
   strelicaDesnoFilter.resize(height/6,height/6);
   strelicaDesnoFilter.filter(GRAY);
   strelicaLijevoFilter=loadImage("lijevo.png");
   strelicaLijevoFilter.resize(height/6,height/6);
   strelicaLijevoFilter.filter(GRAY);
 
   
}


String[] TopPlayers=new String[30];
Integer[] HighScores=new Integer[30];

void dohvatiHighscores(){
  //i=ID igre
  //j=redni broj TOPigraca
  
  for(int i=0;i<3;i++){
    for(int j=0;j<10;j++){
      TopPlayers[10*i+j]=str(j+1)+"."+dohvatiImeIgraca(j+1,i+1);
      HighScores[10*i+j]=dohvatiBrojBodova(j+1,i+1);
    }
  }
}
