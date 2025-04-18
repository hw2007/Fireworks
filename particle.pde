class Particle
{
  float x, y;
  float size;
  color col;
  float velocityX, velocityY;
  
  int life;
  boolean alive = true;
  
  Particle(float tempX, float tempY, float tempSize, color tempCol, float speed, float direction, int tempLife)
  {
    x = tempX;
    y = tempY;
    size = tempSize;
    col = tempCol;
    life = tempLife;
    
    velocityX = sin(direction) * speed;
    velocityY = cos(direction) * speed;
  }
  
  void tick()
  {
    if (!alive)
    {
      return;
    }
    
    life--;
    
    velocityX *= DAMPING;
    velocityY += GRAVITY;
    
    x += velocityX;
    y += velocityY;
    
    trailManager.addTrail(x, y, size, col, 20);
    
    if (life == 0)
    {
      alive = false;
    }
  }
  
  void render()
  {
    if (!alive)
    {
      return;
    }
    
    noStroke();
    fill(col);
    
    ellipse(x, y, size, size);
  }
}
