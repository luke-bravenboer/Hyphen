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
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	public class Render extends Sprite
	{
		//RENDER SHIT
		private var scene:IsoScene;
		private var panPt:Point;
		var view:IsoView = new IsoView();
		private var zoom:Number = 1;
		var g:IsoGrid = new IsoGrid();
		private var gridRect:Array = new Array();
		
		
		//GUI SHIT
		var zoomIN:ImageSprite = new ImageSprite();
		var zoomOUT:ImageSprite = new ImageSprite();
		var grass:ImageSprite = new ImageSprite();
		var myImgLoader:Loader;
		var coins:TextField = new TextField();
		
		public static var myText:TextField = new TextField();
		
		public function Render ()
		{
			renderScene();
			renderGUI();
			var myTimer:Timer = new Timer(1000); // 1 second
			myTimer.addEventListener(TimerEvent.TIMER, updateGUI);
			myTimer.start();
		}
		public function renderGUI(){
			coins.x=100;
			coins.y=10;
			coins.border = true;
			coins.wordWrap = true;
			coins.width = 100;
			coins.height = 50;
			coins.text="OLD";
			addChild(coins);
			
			//debug box
			myText = new TextField();
			myText.text = "TEST   ";
			addChild(myText);
			myText.border = true;
			myText.wordWrap = true;
			myText.width = 200;
			myText.height = 100;
			myText.x = 250;
			myText.y = 300;
			
			
			//load images
			//load zoom images
			zoomOUT.addEventListener(MouseEvent.CLICK,viewZoomOut);
			zoomIN.addEventListener(MouseEvent.CLICK,viewZoomIn);
			zoomOUT.setPosition(349,141,50);
			zoomOUT.load(this,"assets/images/zoomOut.png");
			zoomIN.setPosition(349,99,50);
			zoomIN.load(this,"assets/images/zoomIn.png");
			
			scene.render();
		}
		public function updateGUI(e:Event){
			coins.text=""+zoom;
			scene.render();
		}
		public function renderScene(){
			g.showOrigin=true;
			scene = new IsoScene();
			g.cellSize = 25;
			g.setGridSize(10,10,0);
			g.autoUpdate = true;
			scene.addChild(g);
			
			//create ground			
			loadImage("assets/images/grass.png");
			
			
			//set view
			view.clipContent = true;
			view.zoom(0.8);
			view.y = 0;
			view.setSize(400, 300);
			view.addScene(scene);
			addChild(view);
			view.addEventListener(MouseEvent.MOUSE_DOWN, viewMouseDown);
			view.addEventListener(MouseEvent.MOUSE_WHEEL, viewZoom);
			
		}
		
		private function loadImage(url:String):void{
			var loader : Loader = new Loader();
			loader.load(new URLRequest(url));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imgLoadComplete);
		}
		
		private function imgLoadComplete(e:Event):void
		{
			//myText.text = e.target.url.toString();
			if(e.target.url.toString().substr(e.target.url.toString().length-9) == "grass.png"){
				var myImg:Bitmap = new Bitmap(e.target.content.bitmapData);
				for(var i = 0; i < 10; i++){
					for(var j = 0; j < 10; j++){
						var rect : IsoRectangle = new IsoRectangle();
						rect.stroke=null;
						rect.setSize(25,25,0);
						rect.moveTo(i*25, j*25, 0);
						scene.addChild(rect);
						gridRect.push(rect);
						gridRect[i*10+j].fills = [new BitmapFill(myImg, IsoOrientation.XY)];	
					}
				}
			} 
			scene.render();
		}
		
		
		//mouse functions
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