package
{
	public class BuildingSprite extends ImageSprite
	{
		public function BuildingSprite(){
			super();
		}
		
		override private function imgLoadComplete(e:Event):void{
			bitmap = new Bitmap(e.target.content.bitmapData).bitmapData;
			if (r==null)return;
			
			//TODO: move to correct 
			
		/*	graphics.moveTo(xPos,yPos);
			graphics.beginBitmapFill(bitmap);
			graphics.drawRect(xPos,yPos,wid,wid);
			graphics.endFill();	*/
			
			
			r.addChild(this);
		} 
	}
}