package
{       
	import as3isolib.core.IIsoDisplayObject;
	import as3isolib.display.IsoSprite;
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
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import flashx.textLayout.tlf_internal;
	
	import mx.core.BitmapAsset;
	
	public class Render extends Sprite
	{
		private static var SCR_WID : int = 400;
		private static var SCR_HGT : int = 300;
		private static var gridSize:int = 10;
		private static var gridWidth:int = 25;
		
		//IMAGES
		private var garage:ImageSprite = new ImageSprite();
		
		
		//RENDER SHIT
		private var scene:IsoScene;
		private var panPt:Point;
		private var view:IsoView = new IsoView();
		private var zoom:Number = 1;
		private var g:IsoGrid = new IsoGrid();
		private var gridRect:Array = new Array();
		private var buildingGrid:Array  = new Array(100);
		
		
		//GUI SHIT
		private var zoomIN:ImageSprite = new ImageSprite();
		private var zoomOUT:ImageSprite = new ImageSprite();
		private var grass:ImageSprite = new ImageSprite();
		private var myImgLoader:Loader;
		private var coins:TextField = new TextField();
		private var build:ImageSprite = new ImageSprite();
		
		//GLOBAL SHIT
		private var building:Boolean = false;
		
		public static var myText:TextField = new TextField();
		
		public function Render (){
			stage.nativeWindow.height=800;
			stage.nativeWindow.width=1000;
			renderScene();
			renderGUI();
			var myTimer:Timer = new Timer(1000); // 1 second
			myTimer.addEventListener(TimerEvent.TIMER, updateGUI);
			myTimer.start();
		}
		public function renderGUI():void{
			
			
			
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
			zoomOUT.setPosition(SCR_WID-51,SCR_HGT/2-50);
			zoomOUT.load(this,"assets/images/zoomOut.png");
			zoomIN.setPosition(SCR_WID-51,SCR_HGT/2+50);
			zoomIN.load(this,"assets/images/zoomIn.png");
			//load build image
			build.addEventListener(MouseEvent.CLICK, beginBuild);
			build.setPosition(25, 301);
			build.load(this,"assets/images/build.png");
			
			scene.render();
		}
		
		public function updateGUI(e:Event):void{
			coins.text=""+zoom;
			scene.render();
			if (building)buildDragEffect();
		}
		
		public function renderScene():void{
			//load buildings images
			garage.overrideSize(50,50);
			garage.load(null,"assets/images/garage.png");
			
			
			
			
			g.showOrigin=true;
			scene = new IsoScene();
			g.cellSize = 25;
			g.setGridSize(gridSize,gridSize,0);
			g.autoUpdate = true;
			scene.addChild(g);
			
			//create ground			
			loadImage("assets/images/grass.png");
			
			
			//set view
			view.clipContent = true;
			view.zoom(0.8);
			view.y = 0;
			view.setSize(SCR_WID, SCR_HGT);
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
				for(var i:int = 0; i < 10; i++){
					for(var j:int = 0; j < 10; j++){
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
		
		private function beginBuild(e:MouseEvent):void{
			building = true;
		}
		private function place(x:int,y:int){
			//TODO - MAKE IT PLACE BUILDING AT POSITION
			
			var buildingSprite:IsoSprite = new IsoSprite();
			buildingSprite.sprites = [garage.bitmap];
			buildingSprite.setSize(gridWidth,gridWidth,0);
			buildingSprite.moveTo(x*gridWidth-gridWidth,y*gridWidth,1);
			scene.addChild(buildingSprite);
			//buildingGrid[y*gridSize+x]=buildingSprite;
			trace (x,y);
			//set to true to enable one build. debug mode.
			//building=false;
			scene.render();
		}
		private function buildDragEffect(){
			
			
			
		}
		//mouse functions
		private function viewMouseDown(e:Event):void{
			
			if (building){
				var pt:Pt = new Pt(e.target.x, e.target.y);
				var squareSize:int = 25; // 
				pt = IsoMath.screenToIso(pt);
				var gridX:int = Math.floor( pt.x / squareSize );
				var gridY:int = Math.floor( pt.y / squareSize );
				
				place(gridX,gridY);
			}
			
			panPt = new Point(stage.mouseX, stage.mouseY);
			view.addEventListener(MouseEvent.MOUSE_MOVE, viewPan);
			view.addEventListener(MouseEvent.MOUSE_UP, viewMouseUp);
		}
		private function viewPan(e:Event):void{
			view.panBy(panPt.x - stage.mouseX, panPt.y - stage.mouseY);
			panPt.x = stage.mouseX;
			panPt.y = stage.mouseY;
		}
		private function viewMouseUp(e:Event):void{
			view.removeEventListener(MouseEvent.MOUSE_MOVE, viewPan);
			view.removeEventListener(MouseEvent.MOUSE_UP, viewMouseUp);
		}
		private function viewZoom(e:MouseEvent):void{
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
		private function viewZoomIn(e:MouseEvent):void{
			if(zoom<2)
			{
				zoom +=  0.10;
			}
			view.currentZoom = zoom;
		}
		private function viewZoomOut(e:MouseEvent):void{
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
