class FireworksManager
{
  ArrayList<Firework> fireworks = new ArrayList<Firework>();
  
  void tick()
  {
    for (Firework firework : fireworks)
    {
      if (simState == 0 || simState == 3)
      {
        firework.tick();
      }
      firework.render();
    }
    
    for (int i = 0; i < fireworks.size(); i++)
    {
      Firework firework = fireworks.get(i);
      
      if (firework.state == 2)
      {
        fireworks.remove(i);
        i--;
      }
    }
  }
  
  void addFirework(float x, float y, float velocityY, int amountOfParticles, int colorIndex)
  {
    fireworks.add(new Firework(x, y, velocityY, amountOfParticles, colorIndex));
  }
}
