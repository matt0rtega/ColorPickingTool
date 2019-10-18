/**
 * loading an image from the web or the harddisk with sDrop.
 */

import drop.*;
import java.awt.*;
import java.awt.event.*;
import java.awt.datatransfer.*;
import javax.swing.*;
import java.io.*;

SDrop drop;

PImage m;

int gridSize;
int rows;
int cols;

boolean paletteFull = false;
boolean mouseMoved = false;
boolean showCopied = false;

ArrayList<String> palette;

String selection = "";
StringSelection data = new StringSelection(selection);
Clipboard clipboard;

void setup() {
  size(400, 400);
  background(255);
  frameRate(30);
  drop = new SDrop(this);

  gridSize = 10;
  rows = floor(width/gridSize);
  cols = floor(width/gridSize);
  clipboard = Toolkit.getDefaultToolkit().getSystemClipboard();
  clipboard.setContents(data, data);

  palette = new ArrayList<String>();

  textSize(32);
  fill(0);
  text("Drag & Drop an Image", 0, 0);

  //palette.add(color(255, 0, 0));
    textSize(24);
    textAlign(CENTER);
}

void draw() {

  int numRows = (int)map(mouseX, 0, width, 2, 50); 
  int rowSize = (int)width/numRows; 
  if (width % rowSize == 0 && mouseMoved) {
    //gridSize = floor(map(mouseX, 0, width, 5, 50));
    paletteFull = false;
    rows = numRows;
    cols = numRows;
    gridSize = floor(width/numRows);
    palette.clear();
    //println("Even");
  } else {
  }
  // flickering background to see the framerate interference
  // when loading an image. there should be none since the images
  // are loaded in their own thread.
  background(255);
  if (m !=null) {
    m.resize(width, height);
    //image(m, 0, 0);

    m.loadPixels();
    for (int x=0; x<rows; x++) {
      for (int y=0; y<cols; y++) {
        int loc = (x * gridSize) + (y*gridSize) * m.width;

        color co = m.pixels[loc];

        palette.add("#" + hex(color(co)));

        fill(co);
        stroke(0);
        rect(x * gridSize, y*gridSize, gridSize, gridSize);
      }
    }
  }
  //println(gridSize, rows);
  println();
  if (palette.size() == rows * cols && paletteFull == false) {
    print(palette);
    paletteFull = true;
  }

  if (m == null) {
    textSize(24);
    textAlign(CENTER);
    fill(0);
    text("Color Picker", width/2, height/2-36);
    text("Drag & Drop an Image", width/2, height/2);
  }

  if (showCopied && frameCount < 25) {
    textSize(24);
    textAlign(CENTER);
    fill(255);
    text("Copied!", width/2, height/2);
  }
}

void mouseMoved() {
  mouseMoved = true;
}



void mousePressed() {
  frameCount = 0;
  showCopied = true;
  
  String colorlist = "" + palette;
  StringSelection data = new StringSelection(colorlist);
  Clipboard clipboard;
  clipboard = Toolkit.getDefaultToolkit().getSystemClipboard();
  clipboard.setContents(data, data);
  
  println("Copied", data);
}



void dropEvent(DropEvent theDropEvent) {
  println("");
  println("isFile()\t"+theDropEvent.isFile());
  println("isImage()\t"+theDropEvent.isImage());
  println("isURL()\t"+theDropEvent.isURL());

  // if the dropped object is an image, then 
  // load the image into our PImage.
  if (theDropEvent.isImage()) {
    println("### loading image ...");
    m = theDropEvent.loadImage();
  }
}
