class Trail
{
  float x, y, size;
  float r, g, b, a;
  int lifeRemaining; // When this reaches 0, the particle disappears
  int originalLife;
  
  boolean alive = true;
  
  Trail(float tempX, float tempY, float tempSize, color col, int life)
  {
    x = tempX;
    y = tempY;
    size = tempSize;
    r = red(col);
    g = green(col);
    b = blue(col);
    a = 255;
    originalLife = life;
    lifeRemaining = life;
  }
  
  void tick()
  {
    lifeRemaining--;
    
    a = (float) lifeRemaining / originalLife * 255;
    
    if (lifeRemaining == 0)
    {
      alive = false;
    }
  }
  
  void render()
  {
    noStroke();
    fill(r, g, b, a);
    
    ellipse(x, y, size, size);
  }
}
