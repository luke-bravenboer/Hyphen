package
{
	public class Building
	{
		public var x: int;
		public var y: int;
		private var prodRate;
		private var sprite:BuildingSprite;
		
		public function Building(){
		}
		
		public function Building(xPos, yPos, productionRate){
			this.x = xPos;
			this.y = yPos;
			this.prodRate = productionRate;
		}
		
		public function loadSprite():void{
			
		}
		
		
	}
}