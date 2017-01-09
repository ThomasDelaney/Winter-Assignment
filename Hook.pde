class Hook extends GameObject
{ 
  boolean hooking = false;
  boolean hookCooling = false;
  boolean hookConnect = false;
  boolean notMoving = true;
  float tempX;
  float tempY;
  float xR;
  float yR;
  float scale = 1;
  int hookDir;
  float hookTime = 0;
  
  Hook(float x, float y)
  {
    pos = new Vec2 (x, y);
  }
  
  void render(float theta)
  {
    if (hookDir == 1 || hookDir == 2)
    {
      pushMatrix();
      
      translate(pos.x, pos.y);
      rotate(theta);
          
      beginShape();
      stroke(0);
      strokeWeight(20);
      strokeCap(SQUARE);
      vertex(-15, -1);
      vertex(-8, -1);
      endShape();
      
      beginShape();
      noFill();
      strokeWeight(5);
      strokeCap(ROUND);
      bezier(-8, -1, 39.7, -11.2, 29.7, 24.8, 9.4, 8.8);
      endShape();
      
      popMatrix();
    }
    else if (hookDir == 3 || hookDir == 4)
    {
      pushMatrix();
      
      translate(pos.x, pos.y);
      rotate(theta);
       
      beginShape();
      stroke(0);
      strokeWeight(20);
      strokeCap(SQUARE);
      vertex(0, 0);
      vertex(7, 0);
      endShape();
  
    
      beginShape();
      noFill();
      strokeWeight(5);
      strokeCap(ROUND);
      bezier(5.2, 1.4, -49.4, -11.7, -46.2, 20, -19.8, 12.3);
      endShape();
      
      popMatrix();
    }
  }
  
  void update(Player p)
  {
    stroke(0);
    strokeWeight(3);
    
    float cX = (p.pos.x+pos.x)/2;
    float cY = (p.pos.y+pos.y)/2;
    
    float dX = pos.x - cX;
    float dY = pos.y - cY;
    
    float theta = atan(dY/dX);
    
    line(p.pos.x, p.pos.y, pos.x, pos.y);
      
    if (!hookConnect)
    {
      if (pos.x <= platPosX && pos.y <= platPosY)
      {
        tempX = platPosX - pos.x;
        tempY = platPosY - pos.y;
          
        xR = (tempX/platPosX)*scale;
        yR = (tempY/platPosY)*scale;
          
        pos.x+=xR;
        pos.y+=yR;
          
        hookDir = 1;
      }
      else if (pos.x <= platPosX && pos.y >= platPosY)
      {
        tempX = platPosX - pos.x;
        tempY = pos.y - platPosY;
         
        xR = (tempX/platPosX)*scale;
        yR = (tempY/platPosY)*scale;
          
        pos.x+=xR;
        pos.y-=yR;
          
        hookDir = 2;
      }
      else if (pos.x >= platPosX && pos.y >= platPosY)
      {
        tempX = pos.x - platPosX;
        tempY = pos.y -  platPosY;
         
        xR = (tempX/platPosX)*scale;
        yR = (tempY/platPosY)*scale;
          
        pos.x-=xR;
        pos.y-=yR;
          
        hookDir = 3;
      }
      else if (pos.x >= platPosX && pos.y <= platPosY)
      {
        tempX = pos.x - platPosX;
        tempY = platPosY - pos.y;
                    
        xR = (tempX/platPosX)*scale;
        yR = (tempY/platPosY)*scale;
          
        pos.x-=xR;
        pos.y+=yR;
         
        hookDir = 4;
      }
        
      scale += 1.5;
        
      if (hookDir == 1)
      {
        render(theta);
        
        if (pos.x+1 >= platPosX && pos.y+1 >= platPosY)
        {
          hookConnect = true;
        }
      }
      else if (hookDir == 2)
      {
        render(theta);
        
        if (pos.x+1 >= platPosX && pos.y <= platPosY+1)
        {
          hookConnect = true;
        }
      }
      else if (hookDir == 3)
      {
        render(theta);
        
        if (pos.x <= platPosX+1 && pos.y <= platPosY+1)
        {
          hookConnect = true;
        }
      }
      else if (hookDir == 4)
      {
        render(theta);
        
        if (pos.x <= platPosX+1 && pos.y+1 >= platPosY)
        {
          hookConnect = true;
        }
      }
    }
       
    if (hookConnect)
    {
      Vec2 vel = p.body.getLinearVelocity();
        
      if (notMoving)
      {
        if (pos.y >= platPosY && pos.x >= platPosX)
        {
          vel.y = 40;
          vel.x = -40;
        }
        else if (pos.y >= platPosY && pos.x <= platPosX)
        {
          vel.y = 40;
          vel.x = 40;
        }
        else if (pos.y <= platPosY && pos.x >= platPosX)
        {
          vel.y = -40;
          vel.x = -40;
        }
        else if (pos.y <= platPosY && pos.x <= platPosX)
        {
          vel.y = -40;
          vel.x = 40;
        }
        
        p.body.setLinearVelocity(vel);
          
        notMoving = false;
      }
        
      if (hookTime > 1)
      {
        hookCooling = true;
        hooking = false;
        hookConnect = false;
        notMoving = true;
        hookTime = 0;
          
        Vec2 vel2 = p.body.getLinearVelocity();
        vel2.x = vel2.x/2;
        vel2.y = vel2.y/2;
        p.body.setLinearVelocity(vel2);
      }
        
      hookTime += timeDelta;
    }
  }
}