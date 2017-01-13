class Player extends GameObject
{
  Vec2 force;
  Hook h;
  float theta;
  char left, right, hook;
  float radius;
  float power = 10000;
  float mass = 1;
  color c;
  boolean reset = false;
  boolean returned = true;
  
  Player(float x, float y, float theta, float w_, float h_, char left, char right, char hook, color c)
  {
    
    forward = new Vec2(0, -1);
    force = new Vec2(0, 0);
     
    this.theta = theta;
    this.w_ = w_;
    this.h_ = h_;
    
    this.left = left;
    this.right = right;
    this.hook = hook;
    this.c = c;
    
    makeBody(new Vec2(x, y), w_, h_);
    
    h = new Hook(x, y);
    h.setPlayer(this);
  }
  
  void update()
  { 
    applyForce();
    pos = box2d.getBodyPixelCoord(body);
    theta = body.getAngle();
    
    if (checkKey(left) && h.notMoving)
    {
      Vec2 vel = body.getLinearVelocity();
      vel.x = -10;
      body.setLinearVelocity(vel);
    }
    
    if (checkKey(right) && h.notMoving)
    {
      Vec2 vel = body.getLinearVelocity();
      vel.x = 10;
      body.setLinearVelocity(vel);
    }
    
    if (checkKey(hook))
    {    
      if (!h.hooking && overPlat && !h.hookCooling && !h.hookConnect)
      {
        h.hooking = true;
    
        h.pos.x = pos.x;
        h.pos.y = pos.y;
      }
    }
    
    if (checkKey(' ') && returned && !h.hookConnect)
    {
      Vec2 vel = body.getLinearVelocity();
      vel.y = 25;
      body.setLinearVelocity(vel);
      returned = false;
    }
  
    if (h.hooking)
    {
      h.update();
    }
    
    if (!h.hooking)
    {
      if (h.hookCooling)
      {
        h.hookTime += timeDelta;
      
        if (h.hookTime > 2)
        {
          h.hookCooling = false;
          h.hookTime = 0;
          h.scale = 1;
        }
      }
    }
    
  }  
  
  void render()
  { 
    pos = box2d.getBodyPixelCoord(body);
  
    pushMatrix();
    
    translate(pos.x-32, pos.y+23);
   
    beginShape();
    noStroke();
    fill(101, 242, 139);
    vertex(0,0);
    vertex(44, -32);
    vertex(50, 0);
    endShape();
       
    beginShape();
    strokeWeight(1);
    strokeCap(ROUND);
    stroke(0);
    fill(101, 242, 139);
    bezier(0, 0, -0.45, -6.83, 5.7, -9.58, 9.03, -6.76);
    bezier(9.03, -6.76, 8.8, -12.9, 12.7, -14.86, 18.3, -13.03);
    bezier(18.3, -13.03, 18.34, -18.53, 22.5, -21.63, 28.86, -18.9); 
    bezier(28.86, -18.9, 28.84, -29.3, 36.9, -32.25, 43.32, -32.3); 
    bezier(43.32, -32.3, 55.44, -29.13, 61.4, -15.2, 50, 0);
    endShape();
    
    beginShape();
    strokeWeight(1);
    strokeCap(ROUND);
    stroke(0);
    vertex(0, 0);
    vertex(50, 0);
    endShape();
    
    beginShape();
    strokeWeight(1);
    strokeCap(ROUND);
    stroke(0);
    fill(237, 71, 109);
    vertex(29, -25);
    vertex(19, -40);
    vertex(34, -30);
    endShape();
    
    beginShape();
    strokeWeight(1);
    strokeCap(ROUND);
    stroke(0);
    fill(237, 71, 109);
    vertex(34, -30);
    vertex(33, -48);
    vertex(40, -33);
    endShape();
    
    beginShape();
    strokeWeight(1);
    strokeCap(ROUND);
    stroke(0);
    fill(237, 71, 109);
    vertex(40, -33);
    vertex(45, -50);
    vertex(49, -30);
    endShape();
    
    beginShape();
    strokeWeight(1);
    strokeCap(ROUND);
    stroke(0);
    fill(237, 71, 109);
    vertex(49, -30);
    vertex(58, -48);
    vertex(54, -26);
    endShape();
    
    beginShape();
    fill(0);
    ellipse(46, -23, 2.5, 2.5);
    
    noFill();
    bezier(40, -25, 40.99, -27.73, 42.77, -29.33, 47.49, -28.58);
    endShape();
    
    beginShape();
    strokeWeight(1);
    strokeCap(ROUND);
    stroke(0);
    fill(255);
    vertex(56, -18);
    vertex(42, -17);
    vertex(56, -12);
    endShape();
    
    beginShape();
    strokeWeight(1);
    strokeCap(ROUND);
    stroke(0);
    fill(237, 71, 109);
    vertex(47, -7);
    vertex(59, -11);
    vertex(60, -5);
    vertex(48, -3);
    endShape();
    
    popMatrix();
  }
  
  void makeBody(Vec2 center, float wid, float hei)
  {

    PolygonShape sd = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(wid/2);
    float box2dH = box2d.scalarPixelsToWorld(hei/2);
    sd.setAsBox(box2dW, box2dH);

    FixtureDef fd = new FixtureDef();
    fd.shape = sd;

    fd.density = 1;
    fd.friction = 1;
    fd.restitution = 0;

    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.angle = 0;
    
    bd.position.set(box2d.coordPixelsToWorld(center));

    body = box2d.createBody(bd);
    body.createFixture(fd);
    body.setUserData(this);

    body.setLinearVelocity(new Vec2(0,0));
  }
  
  void applyForce()
  {
    Vec2 pos2 = body.getWorldCenter();
    force.x = 0;
    force.y = -150;
    body.applyForce(force, pos2);
  }
}