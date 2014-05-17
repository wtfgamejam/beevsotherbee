package scripts;

import com.stencyl.graphics.G;

import com.stencyl.behavior.Script;
import com.stencyl.behavior.ActorScript;
import com.stencyl.behavior.SceneScript;
import com.stencyl.behavior.TimedTask;

import com.stencyl.models.Actor;
import com.stencyl.models.GameModel;
import com.stencyl.models.actor.Animation;
import com.stencyl.models.actor.ActorType;
import com.stencyl.models.actor.Collision;
import com.stencyl.models.actor.Group;
import com.stencyl.models.Scene;
import com.stencyl.models.Sound;
import com.stencyl.models.Region;
import com.stencyl.models.Font;

import com.stencyl.Engine;
import com.stencyl.Input;
import com.stencyl.Key;
import com.stencyl.utils.Utils;

import nme.ui.Mouse;
import nme.display.Graphics;
import nme.display.BlendMode;
import nme.display.BitmapData;
import nme.display.Bitmap;
import nme.events.Event;
import nme.events.KeyboardEvent;
import nme.events.TouchEvent;
import nme.net.URLLoader;

import box2D.dynamics.joints.B2Joint;

import motion.Actuate;
import motion.easing.Back;
import motion.easing.Cubic;
import motion.easing.Elastic;
import motion.easing.Expo;
import motion.easing.Linear;
import motion.easing.Quad;
import motion.easing.Quart;
import motion.easing.Quint;
import motion.easing.Sine;

import com.stencyl.graphics.shaders.BasicShader;
import com.stencyl.graphics.shaders.GrayscaleShader;
import com.stencyl.graphics.shaders.SepiaShader;
import com.stencyl.graphics.shaders.InvertShader;
import com.stencyl.graphics.shaders.GrainShader;
import com.stencyl.graphics.shaders.ExternalShader;
import com.stencyl.graphics.shaders.InlineShader;
import com.stencyl.graphics.shaders.BlurShader;
import com.stencyl.graphics.shaders.ScanlineShader;
import com.stencyl.graphics.shaders.CSBShader;
import com.stencyl.graphics.shaders.HueShader;
import com.stencyl.graphics.shaders.TintShader;
import com.stencyl.graphics.shaders.BloomShader;



class Design_1_1_AsteroidsMovement extends ActorScript
{          	
	
public var _UseAnimations:Bool;

public var _TurnLeftAnimation:String;

public var _TurnRightAnimation:String;

public var _IdleAnimation:String;

public var _PushForwardAnimation:String;

public var _PushBackwardAnimation:String;

public var _UseControls:Bool;

public var _Backward:Bool;

public var _Forward:Bool;

public var _PushForwardControl:String;

public var _TurnRightControl:String;

public var _PushBackwardControl:String;

public var _TurnLeftControl:String;

public var _ForwardForce:Float;

public var _Facing:Float;

public var _Torque:Float;

public var _Front:Float;

public var _BackwardForce:Float;

public var _FrontY:Float;

public var _FrontX:Float;

public var _Turn:Float;

public var _Speed:Float;

public var _MaximumTurningSpeed:Float;

public var _MaximumSpeed:Float;

public var _TurningSign:Float;

public var _DirectionofMotion:Float;

public var _CoasterBreak:Bool;
    
/* ========================= Custom Event ========================= */
public function _customEvent_PushForward():Void
{
        _Forward = true;
propertyChanged("_Forward", _Forward);
}

    
/* ========================= Custom Event ========================= */
public function _customEvent_PushBackward():Void
{
        _Backward = true;
propertyChanged("_Backward", _Backward);
}

    
/* ========================= Custom Event ========================= */
public function _customEvent_TurnLeft():Void
{
        _Turn = asNumber(-1);
propertyChanged("_Turn", _Turn);
}

    
/* ========================= Custom Event ========================= */
public function _customEvent_TurnRight():Void
{
        _Turn = asNumber(1);
propertyChanged("_Turn", _Turn);
}


 
 	public function new(dummy:Int, actor:Actor, engine:Engine)
	{
		super(actor, engine);	
		nameMap.set("Use Animations", "_UseAnimations");
_UseAnimations = true;
nameMap.set("Turn Left Animation", "_TurnLeftAnimation");
nameMap.set("Turn Right Animation", "_TurnRightAnimation");
nameMap.set("Idle Animation", "_IdleAnimation");
nameMap.set("Push Forward Animation", "_PushForwardAnimation");
nameMap.set("Push Backward Animation", "_PushBackwardAnimation");
nameMap.set("Actor", "actor");
nameMap.set("Use Controls", "_UseControls");
_UseControls = true;
nameMap.set("Backward", "_Backward");
_Backward = false;
nameMap.set("Forward", "_Forward");
_Forward = false;
nameMap.set("Push Forward Control", "_PushForwardControl");
nameMap.set("Turn Right Control", "_TurnRightControl");
nameMap.set("Push Backward Control", "_PushBackwardControl");
nameMap.set("Turn Left Control", "_TurnLeftControl");
nameMap.set("Forward Force", "_ForwardForce");
_ForwardForce = 10.0;
nameMap.set("Facing", "_Facing");
_Facing = -90.0;
nameMap.set("Torque", "_Torque");
_Torque = 100.0;
nameMap.set("Front", "_Front");
_Front = 0.0;
nameMap.set("Backward Force", "_BackwardForce");
_BackwardForce = 5.0;
nameMap.set("Front Y", "_FrontY");
_FrontY = 0.0;
nameMap.set("Front X", "_FrontX");
_FrontX = 0.0;
nameMap.set("Turn", "_Turn");
_Turn = 0.0;
nameMap.set("Speed", "_Speed");
_Speed = 0.0;
nameMap.set("Maximum Turning Speed", "_MaximumTurningSpeed");
_MaximumTurningSpeed = 100.0;
nameMap.set("Maximum Speed", "_MaximumSpeed");
_MaximumSpeed = 50.0;
nameMap.set("Turning Sign", "_TurningSign");
_TurningSign = 0.0;
nameMap.set("Direction of Motion", "_DirectionofMotion");
_DirectionofMotion = 0.0;
nameMap.set("Coaster Break", "_CoasterBreak");
_CoasterBreak = false;

	}
	
	override public function init()
	{
		    
/* ======================== When Updating ========================= */
addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void {
if(wrapper.enabled){
        _Front = asNumber((Utils.DEG * (actor.getAngle()) + _Facing));
propertyChanged("_Front", _Front);
        _Speed = asNumber(Math.sqrt((Math.pow(actor.getXVelocity(), 2) + Math.pow(actor.getYVelocity(), 2))));
propertyChanged("_Speed", _Speed);
        _DirectionofMotion = asNumber(Utils.DEG * (Math.atan2(actor.getYVelocity(), actor.getXVelocity())));
propertyChanged("_DirectionofMotion", _DirectionofMotion);
        if(_UseControls)
{
            _Forward = isKeyDown(_PushForwardControl);
propertyChanged("_Forward", _Forward);
            _Backward = isKeyDown(_PushBackwardControl);
propertyChanged("_Backward", _Backward);
            _Turn = asNumber((asNumber(isKeyDown(_TurnRightControl)) - asNumber(isKeyDown(_TurnLeftControl))));
propertyChanged("_Turn", _Turn);
}

        if(!(_Turn == 0))
{
            actor.applyTorque(Utils.RAD*((_Turn * _Torque)));
}

        _TurningSign = asNumber((Utils.DEG * (actor.getAngularVelocity()) / Math.abs(Utils.DEG * (actor.getAngularVelocity()))));
propertyChanged("_TurningSign", _TurningSign);
        if((Math.abs(Utils.DEG * (actor.getAngularVelocity())) > _MaximumTurningSpeed))
{
            actor.setAngularVelocity(Utils.RAD * ((_TurningSign * _MaximumTurningSpeed)));
}

        if(_Forward)
{
            actor.pushInDirection(_Front, _ForwardForce);
}

        else if(_Backward)
{
            if(_CoasterBreak)
{
                if((_Speed > 0.1))
{
                    actor.pushInDirection((_DirectionofMotion - 180), _BackwardForce);
}

                if((Math.abs(Utils.DEG * (actor.getAngularVelocity())) > 1))
{
                    actor.applyTorque(Utils.RAD*((-(_TurningSign) * _Torque)));
}

}

            else
{
                actor.pushInDirection((_Front - 180), _BackwardForce);
}

}

        if((_Speed > _MaximumSpeed))
{
            actor.setVelocity(_DirectionofMotion, _MaximumSpeed);
}

        if(_UseAnimations)
{
            if(_Forward)
{
                actor.setAnimation("" + _PushForwardAnimation);
}

            else if(_Backward)
{
                actor.setAnimation("" + _PushBackwardAnimation);
}

            else if((_Turn == -1))
{
                actor.setAnimation("" + _TurnLeftAnimation);
}

            else if((_Turn == 1))
{
                actor.setAnimation("" + _TurnRightAnimation);
}

            else
{
                actor.setAnimation("" + _IdleAnimation);
}

}

}
});
    
/* ========================= When Drawing ========================= */
addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void {
if(wrapper.enabled){
        if((sceneHasBehavior("Game Debugger") && asBoolean(getValueForScene("Game Debugger", "_Enabled"))))
{
            g.strokeColor = getValueForScene("Game Debugger", "_CustomColor");
            g.strokeSize = Std.int(getValueForScene("Game Debugger", "_StrokeThickness"));
            g.translateToScreen();
            _FrontX = asNumber(Math.cos(Utils.RAD * (_Front) * Utils.RAD));
propertyChanged("_FrontX", _FrontX);
            _FrontY = asNumber(Math.sin(Utils.RAD * (_Front) * Utils.RAD));
propertyChanged("_FrontY", _FrontY);
            if(_Forward)
{
                g.drawLine(((actor.getXCenter() - (_ForwardForce * _FrontX)) - getScreenX()), ((actor.getYCenter() - (_ForwardForce * _FrontY)) - getScreenY()), (actor.getXCenter() - getScreenX()), (actor.getYCenter() - getScreenY()));
}

            if(_Backward)
{
                if(_CoasterBreak)
{
                    if((_Speed > 0.1))
{
                        g.drawLine(((actor.getXCenter() - (_BackwardForce * -(Math.cos(Utils.RAD * (_DirectionofMotion) * Utils.RAD)))) - getScreenX()), ((actor.getYCenter() - (_BackwardForce * -(Math.sin(Utils.RAD * (_DirectionofMotion) * Utils.RAD)))) - getScreenY()), (actor.getXCenter() - getScreenX()), (actor.getYCenter() - getScreenY()));
}

                    if((Math.abs(Utils.DEG * (actor.getAngularVelocity())) > 1))
{
                        g.drawLine((((actor.getXCenter() + ((actor.getWidth()/2) * _FrontX)) + ((-(_TurningSign) * _Torque) * _FrontY)) - getScreenX()), (((actor.getYCenter() + ((actor.getHeight()/2) * _FrontY)) + ((-(_TurningSign) * _Torque) * -(_FrontX))) - getScreenY()), ((actor.getXCenter() + ((actor.getWidth()/2) * _FrontX)) - getScreenX()), ((actor.getYCenter() + ((actor.getHeight()/2) * _FrontY)) - getScreenY()));
}

}

                else
{
                    g.drawLine(((actor.getXCenter() - (_BackwardForce * -(_FrontX))) - getScreenX()), ((actor.getYCenter() - (_BackwardForce * -(_FrontY))) - getScreenY()), (actor.getXCenter() - getScreenX()), (actor.getYCenter() - getScreenY()));
}

}

            if(!(_Turn == 0))
{
                g.drawLine((((actor.getXCenter() + ((actor.getWidth()/2) * _FrontX)) + ((_Torque * _Turn) * _FrontY)) - getScreenX()), (((actor.getYCenter() + ((actor.getHeight()/2) * _FrontY)) + ((_Torque * _Turn) * -(_FrontX))) - getScreenY()), ((actor.getXCenter() + ((actor.getWidth()/2) * _FrontX)) - getScreenX()), ((actor.getYCenter() + ((actor.getHeight()/2) * _FrontY)) - getScreenY()));
}

}

}
});

	}	      	
	
	override public function forwardMessage(msg:String)
	{
		
	}
}