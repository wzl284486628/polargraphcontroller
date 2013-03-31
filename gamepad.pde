ControllIO controllIO;
ControllDevice joypad;

ControllButton buttonA;
ControllButton buttonB;
ControllButton buttonX;
ControllButton buttonY;

ControllCoolieHat dpad;


String inputDeviceName = "Controller (Xbox 360 Wireless Receiver for Windows)";


String signalFromGamepad = null;

static final String BUTTON_A_RELEASED = "ButtonAReleased";
static final String BUTTON_B_RELEASED = "ButtonBReleased";

void gamepad_init()
{
  controllIO = ControllIO.getInstance(this);

  try
  {
    joypad = controllIO.getDevice(inputDeviceName);
    joypad.printButtons();
  
    buttonA = joypad.getButton("Button 0");
    buttonB = joypad.getButton("Button 1");
    buttonX = joypad.getButton("Button 2");
    buttonY = joypad.getButton("Button 3");
    
    buttonA.plug(this, "buttonARelease", ControllIO.ON_RELEASE);
    buttonB.plug(this, "buttonBRelease", ControllIO.ON_RELEASE);
    buttonX.plug(this, "buttonXPress", ControllIO.ON_PRESS);
    buttonX.plug(this, "buttonXRelease", ControllIO.ON_RELEASE);
    buttonY.plug(this, "buttonYRelease", ControllIO.ON_RELEASE);
    
    dpad = joypad.getCoolieHat(10);
    dpad.setMultiplier(4);
    dpad.plug(this, "dpadPress", ControllIO.ON_PRESS);
    
  }
  catch (RuntimeException e)
  {
    println("Requested device (" + inputDeviceName + ") not found.");
  }
}

public void buttonARelease()
{
  signalFromGamepad = BUTTON_A_RELEASED;
}
public void buttonBRelease()
{
  signalFromGamepad = BUTTON_B_RELEASED;
}

void buttonXPress()
{
  drawingLiveVideo = true;
}
void buttonXRelease()
{
  drawingLiveVideo = false;
}
void buttonYRelease()
{
  flipWebcamImage = !flipWebcamImage;
}

void dpadPress(float x, float y)
{
  println("VAl:" + dpad.getValue());
  float val = dpad.getValue();
  if (val == 2.0)
  {
    liveSimplification--;
    if (liveSimplification < LIVE_SIMPLIFICATION_MIN)
      liveSimplification = LIVE_SIMPLIFICATION_MIN;
  }
  else if (val == 6.0)
  {
    liveSimplification++;
    if (liveSimplification > LIVE_SIMPLIFICATION_MAX)
      liveSimplification = LIVE_SIMPLIFICATION_MAX;
  }

  Numberbox n = (Numberbox) getAllControls().get(MODE_LIVE_SIMPLIFICATION_VALUE);
  n.setValue(liveSimplification);
  n.update();

}

void processGamepadInput()
{
  if (signalFromGamepad != null)
  {
    if (signalFromGamepad == BUTTON_A_RELEASED)
      if (captureShape == null)
        button_mode_liveCaptureFromLive(); 
      else
        button_mode_liveClearCapture();
    else if (signalFromGamepad == BUTTON_B_RELEASED)
      button_mode_liveConfirmDraw();
      
      
    // clear the signal  
    signalFromGamepad = null;
  }
  
}
