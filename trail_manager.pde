class TrailManager
{
  ArrayList<Trail> trails = new ArrayList<Trail>();
  
  void tick()
  {
    for (Trail trail : trails)
    {
      if (simState == 0 || simState == 3)
      {
        trail.tick();
      }
      trail.render();
    }
    
    for (int i = 0; i < trails.size(); i++)
    {
      Trail trail = trails.get(i);
      
      if (!trail.alive)
      {
        trails.remove(i);
        i--;
      }
    }
  }
  
  void addTrail(float x, float y, float size, color col, int life)
  {
    trails.add(new Trail(x, y, size, col, life));
  }
}
