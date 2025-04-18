class Firework
{
  ArrayList<Particle> particles = new ArrayList<Particle>();
  
  float x, y;
  float velocityY;
  float endY; // When y reaches this point, the firework explodes
  int amountOfParticles; // Amount of particles to spawn on explode
  int colorIndex; // Color to explode with, as an index of COLORS array
  
  int state = 0;
  
  final int SIZE = 15;
  final int CLR_RANDOM = 80;
  
  Firework(float tempX, float tempEndY, float tempVelocityY, int tempAmountOfParticles, int tempColorIndex)
  {
    x = tempX;
    y = height / zoom + SIZE / 2;
    velocityY = tempVelocityY;
    endY = tempEndY;
    amountOfParticles = tempAmountOfParticles;
    colorIndex = tempColorIndex;
  }
  
  void tick()
  {
    if (state == 0)
    {
      y -= velocityY;
      trailManager.addTrail(x, y, SIZE, color(255), 60);
      
      if (y <= endY)
      {
        y = endY;
        state = 1;
        
        if (colorIndex == 0)
        {
          colorIndex = (int) random(1, COLORS.length);
        }

        for (int i = 0; i < amountOfParticles; i++)
        {
          color clr;
          
          if (colorIndex == 1)
          {
            clr = color(random(255), random(255), random(255));
          }
          else
          {
            clr = COLORS[colorIndex];
            clr = color(red(clr) + random(-CLR_RANDOM, CLR_RANDOM), green(clr) + random(-CLR_RANDOM, CLR_RANDOM), blue(clr) + random(-CLR_RANDOM, CLR_RANDOM));
          }
          particles.add(new Particle(x + random(-20, 20), y + random(-20, 20), random(8, 12), clr, random(6, 10), random(0, 2 * PI), (int) random(40, 80)));
        }
      }
    }
    else if (state == 1)
    {
      boolean areAnyParticlesAlive = false;
      for (Particle particle : particles)
      {
        particle.tick();
        particle.render();
        
        if (particle.alive)
        {
          areAnyParticlesAlive = true;
        }
      }
      
      if (!areAnyParticlesAlive)
      {
        state = 2;
      }
    }
  }
  
  void render()
  {
    if (state == 0)
    {
      noStroke();
      fill(255);
      
      ellipse(x, y, SIZE, SIZE);
      
      if (simState == 1 || simState == 2)
      {
        stroke(100);
        strokeWeight(4);
        line(x - 5, endY - 5, x + 5, endY + 5);
        line(x - 5, endY + 5, x + 5, endY - 5);
      }
    }
  }
}
