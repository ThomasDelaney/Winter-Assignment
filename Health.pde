class Health extends GameObject implements PowerUp
{
  boolean hit = false;
  
  Health(float x, float y, float w_, float h_)
  {
    super(x, y, w_, h_);
  }
  
  void render()
  {
    pos = box2d.getBodyPixelCoord(body);
    
    pushMatrix();
    translate(pos.x, pos.y);
    
    beginShape();
    stroke(0, 255, 89);
    strokeWeight(2);
    fill(255);
    
    rect(0, 0, w_, h_);
    
    strokeWeight(3);
    fill(0, 255, 89);
    
    rect(0, 0, 20, 2.5);
    rect(0, 0, 2.5, 20);
    endShape();
    
    popMatrix(); 
  }
  
  void update()
  {
    if (hit)
    {
      die();
    }
  }
  
  void die()
  {
    body.setTransform(new Vec2(width+100, height-100), body.getAngle());
    powerUps.remove(this);
    box2d.destroyBody(body);
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
    fd.friction = 5;
    fd.restitution = 0;
    
    fd.filter.groupIndex = -4;

    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.angle = 0;
    
    bd.position.set(box2d.coordPixelsToWorld(center));

    body = box2d.createBody(bd);
    body.createFixture(fd);
    body.setUserData(this);

    body.setLinearVelocity(new Vec2(0,0));
  }
}