package
{       
	import as3isolib.core.IIsoDisplayObject;
	import as3isolib.display.IsoView;
	import as3isolib.display.primitive.IsoBox;
	import as3isolib.display.primitive.IsoRectangle;
	import as3isolib.display.scene.IsoGrid;
	import as3isolib.display.scene.IsoScene;
	import as3isolib.enum.IsoOrientation;
	import as3isolib.geom.IsoMath;
	import as3isolib.geom.Pt;
	import as3isolib.graphics.BitmapFill;
	
	import com.gskinner.motion.GTween;
	
	import eDpLib.events.ProxyEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	public class Render extends Sprite
	{
		//RENDER SHIT
		private var myRect:IsoRectangle;
		private var scene:IsoScene;
		private var panPt:Point;
		var view:IsoView = new IsoView();
		private var zoom:Number = 1;
		var g:IsoGrid = new IsoGrid();
		private var gridRect:Array = new Array();
		//GUI SHIT
		private var guiScene:IsoScene;
		private var guiView:IsoView = new IsoView();
		private var zoominData:BitmapData;
		private var zoomoutData:BitmapData;
		var zoomIn:Sprite = new Sprite();
		var zoomOut:Sprite = new Sprite();
		var myImgLoader:Loader;
		
		public function Render ()
		{
			renderScene();
			renderGUI();
		}
		public function renderGUI(){

			loadImage("assets/images/zoomIn.png");
			loadImage("assets/images/zoomOut.png");
			
			
		}
		public function renderScene(){
			g.showOrigin=true;
			scene = new IsoScene();
			g.cellSize = 25;
			g.setGridSize(10,10,0);
			g.autoUpdate = true;
			scene.addChild(g);
			
			for(var i = 0; i < 10; i++){
				for(var j = 0; j < 10; j++){
					var rect : IsoRectangle = new IsoRectangle();
					rect.stroke=null;
					rect.setSize(25,25,0);
					rect.moveTo(i*25, j*25, 0);
					scene.addChild(rect);
					gridRect.push(rect);
				}
			}
			
			loadImage("grass.png");
			
			
			view.clipContent = true;
			view.zoom(0.8);
			view.y = 0;
			view.setSize(400, 300);
			view.addScene(scene);
			addChild(view);
			view.addEventListener(MouseEvent.MOUSE_DOWN, viewMouseDown);
			view.addEventListener(MouseEvent.MOUSE_WHEEL, viewZoom);
			zoomOut.addEventListener(MouseEvent.CLICK,viewZoomOut);
			zoomIn.addEventListener(MouseEvent.CLICK,viewZoomIn);
			
		}
		
		private function loadImage(url:String):void{
			var loader : Loader = new Loader();
			loader.load(new URLRequest(url));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imgLoadComplete);
		}
		
		private function imgLoadComplete(e:Event):void
		{
			trace(e.target.url);
			
			if(e.target.url.toString().substr(e.target.url.toString().length-9) == "grass.png"){
				var myImg:Bitmap = new Bitmap(e.target.content.bitmapData);
				
				for(var i = 0; i < 10; i++){
					for(var j = 0; j < 10; j++){
						gridRect[i*10+j].fills = [new BitmapFill(myImg, IsoOrientation.XY)];	
					}
				}
			} else if(e.target.url.toString().substr(e.target.url.toString().length-10) == "zoomIn.png"){
				zoominData = new Bitmap(e.target.content.bitmapData).bitmapData;
				zoomOut.graphics.moveTo(349,99);
				zoomIn.graphics.beginBitmapFill(zoominData);
				zoomIn.graphics.drawRect(349,99,50,50);
				zoomIn.graphics.endFill();
				addChild(zoomIn);
			} else if(e.target.url.toString().substr(e.target.url.toString().length-11) == "zoomOut.png"){
				zoomoutData = new Bitmap(e.target.content.bitmapData).bitmapData;
				zoomOut.graphics.moveTo(349,151);
				zoomOut.graphics.beginBitmapFill(zoomoutData);
				zoomOut.graphics.drawRect(349,151,50,50);
				zoomOut.graphics.endFill();
				addChild(zoomOut);
			}
			scene.render();
		}
		
		
		
		private function viewMouseDown(e:Event)
		{
			panPt = new Point(stage.mouseX, stage.mouseY);
			view.addEventListener(MouseEvent.MOUSE_MOVE, viewPan);
			view.addEventListener(MouseEvent.MOUSE_UP, viewMouseUp);
		}
		private function viewPan(e:Event)
		{
			view.panBy(panPt.x - stage.mouseX, panPt.y - stage.mouseY);
			panPt.x = stage.mouseX;
			panPt.y = stage.mouseY;
			//renderGUI();
		}
		private function viewMouseUp(e:Event)
		{
			view.removeEventListener(MouseEvent.MOUSE_MOVE, viewPan);
			view.removeEventListener(MouseEvent.MOUSE_UP, viewMouseUp);
		}
		private function viewZoom(e:MouseEvent)
		{
			if(e.delta > 0 && zoom<2)
			{
				zoom +=  0.10;
			}
			if(e.delta < 0 && zoom>0.3)
			{
				zoom -=  0.10;
			}
			view.currentZoom = zoom;
		}
		private function viewZoomIn(e:MouseEvent)
		{
			if(zoom<2)
			{
				zoom +=  0.10;
			}
			view.currentZoom = zoom;
		}
		private function viewZoomOut(e:MouseEvent)
		{
			if( zoom>0.3)
			{
				zoom -=  0.10;
			}
			view.currentZoom = zoom;
		}
		private function enterFrameHandler (evt:Event):void
		{
			
		}
		
	}
}