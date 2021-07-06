import processing.serial.*;
import java.util.*;
import java.text.*;
//import com.google.common.primitives.Floats;
//import DateTime;
//adinda

String portName = "COM3";
Serial port;
int BaudRate = 9600;
String inString;

float[] tdata = new float[1032];
String[] tmpData = new String[1032];

String buff;
PFont font;
float colorGreen;
int lbTemp = 25;
int hbTemp = 35;

//buat perngeprint an HEHE
PrintWriter outputFile;

Date date = new Date();
  //print(date);
SimpleDateFormat formatter = new SimpleDateFormat("dd-MM-yyyy_HHmmss");


void setup(){
  size(1600, 1600);
  
  port = new Serial(this, portName, BaudRate);
  port.bufferUntil('\n');
  
  //font = loadFont("FZLTZHB--B51-0-48.vlw");
  //textFont(font,40);
  
  //print(formatter.format(date));
 
  
  try {
    outputFile = createWriter("data_sensor32x32_"+formatter.format(date)+".txt");
    
  } catch(Exception e){
    e.printStackTrace();
    print("program exit euyy");
    exit();
  }
  outputFile.println(DateTimeNow() + " Beginning of FILE");
  
  
}

void draw(){
  background(0,0,0);
  for(int i = 0; i < 1024;i++){
    colorGreen = map(tdata[i], lbTemp, hbTemp, 255, 0);
    fill(255, colorGreen, 0);
    
    rect((i % 32)*50, floor(i/32)*50,50,50);
    if(tdata[i]<5) {fill(255);} else {fill(0);}
    
    textAlign(CENTER, CENTER);
    textSize(12);
    text(str(tdata[i]), (i % 32)*50+80, floor(i/32)*50+80);
    textSize(12);
    
    text("Relative Temperature " + str(tdata[15]), 50,10);
  }
}

void serialEvent(Serial port){
  inString = port.readString();
  tmpData = (split(inString,','));
  //print(tmpData[1]);
  float temp1 = float(split(tmpData[1],':'))[1];
  //print("INI DIN: ", temp1," ");
  //tdata = float(tmpData[
  for(int i=0; i < 1024; i++){
    if(i == 0){
      tdata[0] = temp1;
    } else {
      //tdata.add(float(tmpData[1+i]));
      tdata[i] = float(tmpData[1+i]);
    }
  }
  //print(inString);
  //for(int i=0; i <= tdata.length;i++){
  //  print("ini i ke ",i," ",tdata[i]);
  //}
  //print(tdata.asList());
  
  outputFile.print(DateTimeNow().toString()+ ", "+inString);
}

void keyPressed(){
  if (key == 'a'){
    //outputFile.println("udahan yak");
    outputFile.print(DateTimeNow()+ " END OF FILE");
    outputFile.flush();
    outputFile.close();
    exit();
  }
}

String DateTimeNow(){
  String auxMonth = String.valueOf(month());
  String auxDay = String.valueOf(day());
  String auxHour = String.valueOf(hour());
  String auxMinute = String.valueOf(minute());
  String auxSecond = String.valueOf(second());
  String auxYear = String.valueOf(year());
  String auxDateNow = auxYear + "/" + auxMonth + "/" + auxDay + " - " + auxHour + ":" + auxMinute + ":" + auxSecond;
  
  return auxDateNow;
}

void stop(){
    outputFile.print(DateTimeNow()+ " END OF FILE");
    outputFile.flush();
    outputFile.close();
    exit();
}
