package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;

	
	/**
	 * ImageSprite is a class to represent the loading and drawing of a single
	 * image object onto a sprite-based interface, such as Render.
	 * General use is to first call setPosition() to define the image location
	 * and position, and then use load() to attempt to load the image.
	 * It will draw to the screen when loading is complete.
	 */
	public class ImageSprite extends Sprite
	{
		public var bitmap:BitmapData;
		public var xPos:int;
		public var yPos:int;
		public var wid:int;
		private var r:Sprite;
		
		public function ImageSprite(){}
		
		/**
		 * Set the position of the sprite relative to the screen.
		 * (Assumes the sprite is a square.)
		 * 
		 * @param x: The x co-ordinate of the leftmost point of the sprite
		 * @param y: The y co-ordinate of the uppermost point of the sprite
		 * @param w: The width of the sprite in pixels
		 */
		public function setPosition(x:int,y:int,w:int):void{
			this.xPos=x;
			this.yPos=y;
			this.wid=w;
		}
		
		/**
		 * Begin loading of the image, given the specified url.
		 * 
		 * @param render: The Sprite object that the image will display onto.
		 * @param url: The location of the image file, local or otherwise. 
		 */
		public function load(render:Sprite,url:String):void{
			r=render;
			loadImage(url);
		}
		
		private function loadImage(url:String):void{
			var loader : Loader = new Loader();
			loader.load(new URLRequest(url));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imgLoadComplete);
		}
		
		/**
		 * This is called when the image has finished loading, and will
		 * display the sprite on the screen at the set position.
		 */
		private function imgLoadComplete(e:Event):void{
			Render.myText.text = e.target.url.toString();	/*debug*/
			bitmap = new Bitmap(e.target.content.bitmapData).bitmapData;
			if (r==null)return;
			graphics.moveTo(xPos,yPos);
			graphics.beginBitmapFill(bitmap);
			graphics.drawRect(xPos,yPos,wid,wid);
			graphics.endFill();
			r.addChild(this);
		}
	}
}