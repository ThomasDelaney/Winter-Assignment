import java.util.*;
import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

Box2DProcessing box2d;

void setup()
{
  size(1280, 720);
  smooth();
  
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.setGravity(0, -10);

  box2d.listenForCollisions();
  
  overPlat = false;
  
  player = new Player(500, 350, 0, 100, 'a', 'd', 'f', color(0, 255, 0));
  p1 = new Platform (width/2,height-300, 300, 10, color(255));
  p2 = new Platform (width/2+200, height-150, 500, 10, color(255, 144, 0));
  
  ground = new Platform (width/2, height-5, width, 10, color(0, 0, 255));

  platforms.add(p1);
  platforms.add(ground);
  platforms.add(p2);
  gameObjects.add(player);
}

void draw()
{
  background(0);
  
  box2d.step();
  
  player.update();
  player.render();
  
  ground.update();
  ground.render();
   
  p1.update();
  p1.render();
  
  p2.update();
  p2.render();
  
  //println("x: " + mouseX);
  //println("y: " + mouseY);
  
  platCheck(player);
}

Platform tempPlat;
Platform p1;
Platform p2;
Platform ground;

Player player;

boolean[] keys = new boolean[1000];

ArrayList<GameObject> gameObjects = new ArrayList<GameObject>();

ArrayList<Platform> platforms = new ArrayList<Platform>();

float timeDelta = 1.0f / 60.0f;

float platPosX;
float platPosY;

boolean overPlat;

void keyPressed()
{ 
  keys[keyCode] = true;
}
 
void keyReleased()
{
  keys[keyCode] = false; 
}

boolean checkKey(int k)
{
  if (keys.length >= k) 
  {
    return keys[k] || keys[Character.toUpperCase(k)];  
  }
  return false;
}

void beginContact(Contact cp) 
{
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();
  
  Body b1 = f1.getBody();
  Body b2 = f2.getBody();

  
  Object o1 = b1.getUserData();
  Object o2 = b2.getUserData();

  if (o1.getClass() == Player.class && o2.getClass() == Platform.class) 
  {
    Player p1 = (Player) o1;
    p1.returned = true;
  }

}

void endContact(Contact cp) 
{
}

void platCheck(Player curPlayer)
{
  if (!curPlayer.hooking)
  {
    for (Platform p: platforms) 
    {
      if (mouseX > p.pos.x && mouseX < p.pos.x+p.w/2 && mouseY > p.pos.y-p.h && mouseY < p.pos.y+p.h)
      {
        fill(255, 0, 0);
        rect(p.pos.x+p.w/4, p.pos.y, p.w/2, 10);
      
        platPosX = p.pos.x+p.w/2-10;
        platPosY = p.pos.y;
        
        overPlat = true;
        break;
      }
      else if (mouseX < p.pos.x && mouseX > p.pos.x-p.w/2 && mouseY > p.pos.y-p.h && mouseY < p.pos.y+p.h) 
      { 
        fill(255, 0, 0);
        rect(p.pos.x-p.w/4, p.pos.y, p.w/2, 10);
      
        platPosX = p.pos.x-p.w/2+10;
        platPosY = p.pos.y;
        
        overPlat = true;
        break;
      }
      else
      {
        overPlat = false;
      }
    }
  }
}