class Button
{
  float x, y, w;
  String txt;
  int value;
  boolean selected = false;
  
  Button(float tempX, float tempY, float tempW, String tempTxt, int tempValue)
  {
    x = tempX;
    y = tempY;
    w = tempW;
    txt = tempTxt;
    value = tempValue;
  }
  
  void render()
  {
    float txtWidth = textWidth(txt);
    
    if (selected)
    {
      fill(255);
    }
    else
    {
      if (isHovered())
      {
        fill(60);
      }
      else
      {
        fill(0);
      }
    }
    stroke(100);
    strokeWeight(4);
    rectMode(CENTER);
    rect(x, y, w, 48);
    
    if (selected)
    {
      fill(0);
    }
    else
    {
      fill(255);
    }
    textSize(32);
    text(txt, x - txtWidth / 2, y + 10);
  }
  
  boolean isHovered()
  {
    return (mouseX >= x - w/2 && mouseX <= x + w/2 && mouseY >= y - 24 && mouseY <= y + 24);
  }
}
