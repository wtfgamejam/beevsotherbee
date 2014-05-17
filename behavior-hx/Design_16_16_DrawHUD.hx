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



class Design_16_16_DrawHUD extends SceneScript
{          	
	
public var _ItemstoDraw:Array<Dynamic>;

public var _Font:Font;

public var _DrawHUD:Bool;

public var _X:Float;

public var _Y:Float;

public var _ActorType:ActorType;

public var _ActorName:String;

public var _CreatedActorsList:Array<Dynamic>;
    public function _customEvent_CreateActors():Void
{
        for(item in cast(_ItemstoDraw, Array<Dynamic>))
{
            if((("" + ("" + item).split(",")[Std.int(0)]).indexOf("[Actor]") >= 0))
{
                _ActorName = ("" + ("" + item).split(",")[Std.int(0)]).substring(Std.int((("" + ("" + item).split(",")[Std.int(0)]).indexOf("]") + 1)), Std.int(("" + ("" + item).split(",")[Std.int(0)]).length));
propertyChanged("_ActorName", _ActorName);
                _ActorType = getActorTypeByName(_ActorName);
                if((hasValue(_ActorType) != false))
{
                    createRecycledActor(_ActorType, asNumber(("" + item).split(",")[Std.int(1)]), asNumber(("" + item).split(",")[Std.int(2)]), Script.FRONT);
                    getLastCreatedActor().anchorToScreen();
                    _CreatedActorsList.push(getLastCreatedActor());
}

}

            else
{
                _CreatedActorsList.push("null");
}

}

}

    public function _customEvent_StartDrawingHUD():Void
{
        _DrawHUD = true;
propertyChanged("_DrawHUD", _DrawHUD);
        _customEvent_CreateActors();
}

    public function _customEvent_StopDrawingHUD():Void
{
        _DrawHUD = false;
propertyChanged("_DrawHUD", _DrawHUD);
        for(item in cast(_CreatedActorsList, Array<Dynamic>))
{
            if((!((item == "null")) && item.isAlive()))
{
                recycleActor(item);
}

}

}

    
/* ========================= Custom Block ========================= */


/* Params are:__Item __Index __X __Y */
public function _customBlock_SetHUDIndex(__Item:String, __Index:Float, __X:Float, __Y:Float):Void
{
        _ItemstoDraw[Std.int(__Index)] = (("" + __Item) + ("" + (("" + ",") + ("" + (("" + __X) + ("" + (("" + ",") + ("" + __Y))))))));
        if((("" + __Item).indexOf("[Actor]") >= 0))
{
            _ActorName = ("" + __Item).substring(Std.int((("" + __Item).indexOf("]") + 1)), Std.int(("" + __Item).length));
propertyChanged("_ActorName", _ActorName);
            _ActorType = getActorTypeByName(_ActorName);
            if((hasValue(_ActorType) != false))
{
                createRecycledActor(_ActorType, __X, __Y, Script.FRONT);
                getLastCreatedActor().anchorToScreen();
                _CreatedActorsList[Std.int(__Index)] = getLastCreatedActor();
}

}

}
    
/* ========================= Custom Block ========================= */


/* Params are:__Index */
public function _customBlock_RemoveHUDIndex(__Index:Float):Void
{
        _ItemstoDraw.splice(Std.int(__Index), 1);
        if((!((_CreatedActorsList[Std.int(__Index)] == "null")) && _CreatedActorsList[Std.int(__Index)].isAlive()))
{
            recycleActor(_CreatedActorsList[Std.int(__Index)]);
            _CreatedActorsList.splice(Std.int(__Index), 1);
}

}
    
/* ========================= Custom Block ========================= */


/* Params are:__Name */
public function _customBlock_ReturnHUDActor(__Name:String):Actor
{
        for(item in cast(_CreatedActorsList, Array<Dynamic>))
{
            if((("" + item) == __Name))
{
                return item;
}

}

        return null;
}

 
 	public function new(dummy:Int, engine:Engine)
	{
		super(engine);
		nameMap.set("Items to Draw", "_ItemstoDraw");
_ItemstoDraw = [];
nameMap.set("Font", "_Font");
nameMap.set("Draw HUD", "_DrawHUD");
_DrawHUD = false;
nameMap.set("X", "_X");
_X = 0.0;
nameMap.set("Y", "_Y");
_Y = 0.0;
nameMap.set("Actor Type", "_ActorType");
nameMap.set("Actor Name", "_ActorName");
_ActorName = "";
nameMap.set("Created Actors List", "_CreatedActorsList");
_CreatedActorsList = [];

	}
	
	override public function init()
	{
		    
/* ======================== When Creating ========================= */
        if(_DrawHUD)
{
            _customEvent_CreateActors();
}

    
/* ========================= When Drawing ========================= */
addWhenDrawingListener(null, function(g:G, x:Float, y:Float, list:Array<Dynamic>):Void {
if(wrapper.enabled){
        if(_DrawHUD)
{
            g.drawString("" + "", 0, 180);
            for(item in cast(_ItemstoDraw, Array<Dynamic>))
{
                if((("" + ("" + item).split(",")[Std.int(0)]).indexOf("[Actor]") < 0))
{
                    g.alpha = (100/100);
                    g.translateToScreen();
                    g.setFont(_Font);
                    if((("" + item).split(",")[Std.int(0)] == "Center"))
{
                        _X = asNumber(((getScreenWidth() / 2) - (_Font.font.getTextWidth(("" + ("" + item).split(",")[Std.int(0)]))/Engine.SCALE / 2)));
propertyChanged("_X", _X);
}

                    else
{
                        _X = asNumber(asNumber(("" + item).split(",")[Std.int(1)]));
propertyChanged("_X", _X);
}

                    if((("" + item).split(",")[Std.int(2)] == "Center"))
{
                        _Y = asNumber(((getScreenHeight() / 2) - (_Font.getHeight()/Engine.SCALE / 2)));
propertyChanged("_Y", _Y);
}

                    else
{
                        _Y = asNumber(asNumber(("" + item).split(",")[Std.int(2)]));
propertyChanged("_Y", _Y);
}

                    g.drawString("" + ("" + item).split(",")[Std.int(0)], _X, _Y);
}

}

}

}
});

	}	      	
	
	override public function forwardMessage(msg:String)
	{
		
	}
}