package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;

	public class ImageSprite extends Sprite
	{
		public var bitmap:BitmapData;
		public var xPos:int;
		public var yPos:int;
		public var wid:int;
		public var image:String;
		var r:Sprite;
		public function ImageSprite()
		{
		}
		public function updatePosition(){
			this.graphics.moveTo(xPos,yPos);
		}
		public function setPosition(x:int,y:int,w:int){
			this.xPos=x;
			this.yPos=y;
			this.wid=w;
		}
		public function load(render:Sprite,st:String){
			image="app:/"+st;
			r=render;
			loadImage(st);
		}
		
		public function loadImage(url:String):void{
			var loader : Loader = new Loader();
			loader.load(new URLRequest(url));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imgLoadComplete);
		}
		
		public function imgLoadComplete(e:Event):void
		{
			Render.myText.text = e.target.url.toString();
			bitmap = new Bitmap(e.target.content.bitmapData).bitmapData;
			if (r==null)return;
			updatePosition();
			graphics.beginBitmapFill(bitmap);
			graphics.drawRect(xPos,yPos,wid,wid);
			graphics.endFill();
			r.addChild(this);
		}
		
		
	}
}