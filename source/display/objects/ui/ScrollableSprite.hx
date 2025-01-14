package display.objects.ui;

import util.CoolUtil.FPSLerp;
import flixel.math.FlxMath;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.input.mouse.FlxMouse;
import flixel.FlxSprite;
import flixel.FlxBasic;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.util.FlxDirectionFlags;
import flixel.math.FlxRect;
import flixel.math.FlxPoint;
import flixel.util.FlxSignal;
import flixel.util.FlxAxes;
import flixel.FlxSprite.IFlxSprite;

class ScrollableSprite extends FlxTypedSpriteGroup<FlxSprite>
{
	public var scrollAxes:FlxAxes = Y;

	public var scrollSignal:FlxSignal = new FlxSignal();

	public var scrollPoint:FlxPoint = new FlxPoint();
	public var scrollableRect:FlxRect = new FlxRect();

	public function scrollTo(point:FlxPoint) {}

	var memberPositions(default, null):Map<FlxSprite, FlxPoint> = [];

	override function add(Sprite:FlxSprite):FlxSprite {
		var returnAdd:FlxSprite = super.add(Sprite);
		memberPositions.set(returnAdd, Sprite.getPosition());
		return returnAdd;
	}

	override function insert(Position:Int, Sprite:FlxSprite):FlxSprite {
		var returnInsert:FlxSprite = super.insert(Position, Sprite);
		memberPositions.set(returnInsert, Sprite.getPosition());
		return returnInsert;
	}

	override function remove(Sprite:FlxSprite, Splice:Bool = false):FlxSprite {
		var returnRemove:FlxSprite = super.remove(Sprite, Splice);

		if (Splice)
			memberPositions.remove(Sprite);
		else
			memberPositions.set(Sprite, null);
		return returnRemove;
	}

	override function set_x(Value:Float):Float {
		var originalX:Float = x;
		var returnX:Float = super.set_x(Value);
		var deltaX:Float = originalX - returnX;
		for (sprite => position in memberPositions)
			position.x -= deltaX;
		scrollableRect.setPosition(x, y);
		return returnX;
	}

	override function set_y(Value:Float):Float {
		var originalY:Float = y;
		var returnY:Float = super.set_y(Value);
		var deltaY:Float = originalY - returnY;
		for (sprite => position in memberPositions)
			position.y -= deltaY;
		scrollableRect.setPosition(x, y);
		return returnY;
	}

	public function new(x:Float = 0, y:Float = 0, width:Float, height:Float, ?maxSize:Int = 0)
	{
		super(x, y, maxSize);
		scrollableRect.width = width;
		scrollableRect.height = height;
		scrollableRect.setPosition(x, y);
	}

	override function update(delta:Float)
	{
		clipRect = scrollableRect;
        
		if (rectOverlapsPoint(scrollableRect, FlxG.mouse.getPosition()) && Math.abs(FlxG.mouse.wheel) > 0) {
			scrollPoint.add(0, FlxG.mouse.wheel * 4);
        }

		scrollPoint.x = FPSLerp.lerp(scrollPoint.x, 0, 0.05);
		scrollPoint.y = FPSLerp.lerp(scrollPoint.y, 0, 0.05);
		// scrollPoint.y = FlxMath.bound(scrollPoint.y, y, height + y);
		updateScroll(scrollPoint);
		super.update(delta);
	}

    function updateScroll(scrollPoint:FlxPoint) {
        forEach((spr:FlxSprite) -> {
            // if (rectOverlapsPoint(new FlxRect()))
            var originalPos:FlxPoint = memberPositions.get(spr);
			originalPos.x += scrollPoint.x;
			originalPos.y += scrollPoint.y;
            spr.setPosition(originalPos.x, originalPos.y);
        });
    }

	static public function rectOverlapsPoint(rect:FlxRect, point:FlxPoint):Bool
	{
		return (point.x >= rect.x) && (point.x < rect.x + rect.width) && (point.y >= rect.y) && (point.y < rect.y + rect.height);
	}
}
