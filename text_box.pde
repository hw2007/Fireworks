class TextBox
{
  float x, y, w;
  String txt;
  String value;
  boolean selected = false;
  boolean showCursor = true;
  
  ArrayList<Character> allowedKeys = new ArrayList<Character>();
  
  TextBox(float tempX, float tempY, float tempW, String tempTxt, String defaultValue, char[] tempAllowedKeys)
  {
    x = tempX;
    y = tempY;
    w = tempW;
    txt = tempTxt;
    value = defaultValue;
    for (int i = 0; i < tempAllowedKeys.length; i++)
    {
      allowedKeys.add(tempAllowedKeys[i]);
    }
  }
  
  void render()
  {
    float txtWidth = textWidth(txt);
    
    fill(0);
    if (selected)
    {
      stroke(255);
    }
    else
    {
      if (isHovered())
      {
        stroke(150);
      }
      else
      {
        stroke(100);
      }
    }
    strokeWeight(4);
    rectMode(CENTER);
    rect(x, y, w, 48);
    
    fill(255);
    textSize(32);
    
    String modifiedValue = value;
    if (selected && showCursor)
    {
      modifiedValue = modifiedValue + "|";
    }
    text(modifiedValue, x - w/2 + 10, y + 10);
    
    textWithBackground(x - w/2 - txtWidth/2 - 20, y, txt);
  }
  
  void tick()
  {
    if (selected)
    {
      for (char keyChar : keys)
      {
        if (keyChar == BACKSPACE)
        {
          if (value.length() > 0)
          {
            value = value.substring(0, value.length() - 1);
          }
        }
        else if (keyChar == ENTER || key == RETURN)
        {
          selected = false;
        }
        else if (allowedKeys.contains(keyChar))
        {
          value = value + keyChar;
        }
      }
      
      if (keys.size() > 0)
      {
        showCursor = true;
      }
      else if (frameCount % 30 == 0)
      {
        showCursor = !showCursor;
      }
    }
  }
  
  boolean isHovered()
  {
    return (mouseX >= x - w/2 && mouseX <= x + w/2 && mouseY >= y - 24 && mouseY <= y + 24);
  }
}
