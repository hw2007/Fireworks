final float GRAVITY = 0.2;
final float DAMPING = 0.99;

ArrayList<Character> keys = new ArrayList<Character>(); // The keys that were pressed on this frame
ArrayList<Character> keysHeld = new ArrayList<Character>(); // The keys that are currently held down

FireworksManager fireworksManager = new FireworksManager();
TrailManager trailManager = new TrailManager();

int simState = 0;
// simState 0 = normal, no UI
// simState 1 = paused, UI shown
// simState 2 = setting up screen saver
// simState 3 = screen saver running

int newAmountOfParticles = 50;

ArrayList<Button> particleAmountButtons = new ArrayList<Button>();
final float particleButtonWidth = 100;

final color[] COLORS = {
  color(0),
  color(0),
  color(255, 0, 0),
  color(0, 255, 0),
  color(0, 0, 255),
  color(255, 0, 226),
  color(255, 226, 0),
  color(0, 255, 180),
  color(255, 255, 255)
};
int selectedColor = 0; // Index 0 is special, and will actually be a random color

ArrayList<Button> colorButtons = new ArrayList<Button>();
final float colorButtonWidth = 100;

Button screenSaverButton;

// UI for fireworks show setup
TextBox minParticleAmount;
TextBox maxParticleAmount;
TextBox timeBetweenFireworks;

Button startFireworksShow;

ArrayList<Button> includedColorButtons = new ArrayList<Button>();

float fireworksShowMinParticles;
float fireworksShowMaxParticles;
float fireworksShowTime;

ArrayList<Integer> includedColors = new ArrayList<Integer>();

// Zoom/pan variables
float zoom = 1;
final float ZOOM_RATE = 0.01;

void setup()
{
  size(800, 600);
  surface.setTitle("Fireworks");
  surface.setResizable(true);
  frameRate(60);
  
  textSize(32);

  int[] particleAmounts = {10, 25, 50, 100, 250, 500, 1000};
  String[] colorNames = {"Rand", "Multi", "Red", "Green", "Blue", "Pink", "Yellow", "Aqua", "White"};
  
  for (int i = 0; i < particleAmounts.length; i++)
  {
    String txt = String.valueOf(particleAmounts[i]);
    Button button = new Button(0, 0, particleButtonWidth, txt, particleAmounts[i]);
    particleAmountButtons.add(button);
  }
  
  for (int i = 0; i < COLORS.length; i++)
  {
    String txt = colorNames[i];
    
    Button button = new Button(0, 0, colorButtonWidth, txt, i);
    colorButtons.add(button);
    
    if (i > 0)
    {
      button = new Button(0, 0, colorButtonWidth, txt, i);
      button.selected = true;
      includedColorButtons.add(button);
    }
  }
  
  String txt = "Start a fireworks show";
  float w = textWidth(txt) + 20;
  screenSaverButton = new Button(width/2, 40, w, txt, 0);
  
  // Fireworks show UI
  char[] numbers = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '.'};
  
  minParticleAmount = new TextBox(width/2, 150, 200, "Min particle amount", "25", numbers);
  maxParticleAmount = new TextBox(width/2, 210, 200, "Max particle amount", "100", numbers);
  timeBetweenFireworks = new TextBox(width/2, 270, 200, "Time between fireworks (s)", "1", numbers);
  
  txt = "Start the show!";
  w = textWidth(txt) + 20;
  startFireworksShow = new Button(width/2, height - 40, w, txt, 0);
}

void draw()
{
  background(0);
  
  // Zoom
  if (keysHeld.contains('-'))
  {
    zoom -= ZOOM_RATE;
  }
  if (keysHeld.contains('='))
  {
    zoom += ZOOM_RATE;
  }

  zoom = constrain(zoom, 0.5, 1);

  pushMatrix();
    scale(zoom);

    trailManager.tick();
    fireworksManager.tick();
  popMatrix();
  
  scale(1);
  positionGUI();

  if (simState == 1)
  {
    textWithBackground(width/2, height/2, "Paused");
    String txt = "Amount of particles";
    textWithBackground(width/2 - particleButtonWidth * particleAmountButtons.size()/2 - textWidth(txt)/2 - 20, height - 100, txt);
    txt = "Explosion color";
    textWithBackground(width/2 - colorButtonWidth * colorButtons.size()/2 - textWidth(txt)/2 - 20, height - 40, txt);
    
    for (Button button : particleAmountButtons)
    {
      button.render();
      button.selected = (button.value == newAmountOfParticles);
    }
    
    for (Button button : colorButtons)
    {
      button.render();
      button.selected = (button.value == selectedColor);
    }
    
    screenSaverButton.render();
  }
  else if (simState == 2)
  {
    textWithBackground(width/2, 40, "Fireworks show setup");
    
    minParticleAmount.tick();
    minParticleAmount.render();
    
    maxParticleAmount.tick();
    maxParticleAmount.render();
    
    timeBetweenFireworks.tick();
    timeBetweenFireworks.render();
    
    textWithBackground(width/2, 330, "Included colors");
    
    includedColors.clear();
    for (Button button : includedColorButtons)
    {
      button.render();
      
      if (button.selected)
      {
        includedColors.add(button.value);
      }
    }
    
    if (includedColors.size() == 0)
    {
      includedColors.add(1);
      includedColorButtons.get(COLORS.length - 2).selected = true;
    }
    
    fireworksShowMinParticles = constrain(strToFloat(minParticleAmount.value), 0, 1000);
    fireworksShowMaxParticles = constrain(strToFloat(maxParticleAmount.value), 0, 1000);
    fireworksShowTime = strToFloat(timeBetweenFireworks.value);
    
    startFireworksShow.render();
  }
  else if (simState == 3)
  {
    int frameTime = (int) (fireworksShowTime * 60);
    if (frameTime < 1)
    {
      frameTime = 1;
    }
    
    if (frameCount % frameTime == 0)
    {
      fireworksManager.addFirework(random(width / zoom), random(height / zoom / 3 * 2), 12, (int) random(fireworksShowMinParticles, fireworksShowMaxParticles), includedColors.get((int) random(includedColors.size())));
    }
  }
  
  keys.clear();
}

float strToFloat(String str)
{
  if (str == "")
  {
    return 0;
  }
  else
  {
    return Float.valueOf(str);
  }
}

void mousePressed()
{
  if (simState == 1)
  {
    for (Button button : particleAmountButtons)
    {
      if (button.isHovered())
      {
        newAmountOfParticles = button.value;
        return;
      }
    }
    
    for (Button button : colorButtons)
    {
      if (button.isHovered())
      {
        selectedColor = button.value;
        return;
      }
    }
    
    if (screenSaverButton.isHovered())
    {
      simState = 2;
      return;
    }
  }
  else if (simState == 2)
  {
    minParticleAmount.selected = minParticleAmount.isHovered();
    maxParticleAmount.selected = maxParticleAmount.isHovered();
    timeBetweenFireworks.selected = timeBetweenFireworks.isHovered();
    
    for (Button button : includedColorButtons)
    {
      if (button.isHovered())
      {
        button.selected = !button.selected;
      }
    }
    
    if (startFireworksShow.isHovered())
    {
      simState = 3;
    }
  }
  
  if (simState < 2)
  {
    fireworksManager.addFirework(mouseX / zoom, mouseY / zoom, 12, newAmountOfParticles, selectedColor);
  }
}

void textWithBackground(float x, float y, String txt)
{
  float txtWidth = textWidth(txt);
  
  fill(0);
  noStroke();
  rectMode(CENTER);
  rect(x, y, txtWidth + 22, 48);
  
  fill(255);
  textSize(32);
  text(txt, x - txtWidth / 2, y + 10);
}

void positionGUI()
{
  for (int i = 0; i < particleAmountButtons.size(); i++)
  {
    Button button = particleAmountButtons.get(i);
    button.x = width/2 - particleButtonWidth * (particleAmountButtons.size() - (i + particleAmountButtons.size()/2 + 1));
    button.y = height - 100;
  }
  
  for (int i = 0; i < colorButtons.size(); i++)
  {
    Button button = colorButtons.get(i);
    button.x = width/2 - colorButtonWidth * (COLORS.length - (i + COLORS.length/2 + 1));
    button.y = height - 40;
    
    if (i > 0)
    {
      button = includedColorButtons.get(i - 1);
      button.x = width/2 - colorButtonWidth * (COLORS.length - (i + COLORS.length/2 + 0.5));
      button.y = 390;
    }
  }
  
  screenSaverButton.x = width/2;
  screenSaverButton.y = 40;
  
  // Fireworks show UI
  minParticleAmount.x = width/2;
  minParticleAmount.y = 150;
  maxParticleAmount.x = width/2;
  maxParticleAmount.y = 210;
  timeBetweenFireworks.x = width/2;
  timeBetweenFireworks.y = 270;
  
  startFireworksShow.x = width/2;
  startFireworksShow.y = height - 40;
}

void keyPressed()
{
  if (!keysHeld.contains(key))
  {
    keysHeld.add(key);
    keys.add(key);
  }
  
  if (key == ' ' || key == ESC)
  {
    if (simState == 1)
    {
      simState = 0;
    }
    else
    {
      simState = 1;
    }
  }
  
  if (key == ESC)
  {
    key = 0;
  }
}

void keyReleased()
{
  if (keysHeld.contains(key))
  {
    keysHeld.remove(keysHeld.indexOf(key));
  }
}
