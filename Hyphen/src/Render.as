package
{       
	import as3isolib.core.IIsoDisplayObject;
	import as3isolib.display.IsoView;
	import as3isolib.display.primitive.IsoBox;
	import as3isolib.display.scene.IsoGrid;
	import as3isolib.display.scene.IsoScene;
	import as3isolib.geom.IsoMath;
	import as3isolib.geom.Pt;
	
	import com.gskinner.motion.GTween;
	
	import eDpLib.events.ProxyEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class Render extends Sprite
	{
		private var box:IIsoDisplayObject;
		private var scene:IsoScene;
		private var panPt:Point;
		var view:IsoView = new IsoView();
		private var zoom:Number = 1;

		public function Render ()
		{
			scene = new IsoScene();
			
			var g:IsoGrid = new IsoGrid();
			g.setSize(100,100,1);
			
			g.showOrigin = true;
			g.autoUpdate = true;
			g.addEventListener(MouseEvent.CLICK, grid_mouseHandler);
			scene.addChild(g);
			
			box = new IsoBox();
			box.setSize(25, 25, 25);
			scene.addChild(box);
			
			
			view.clipContent = true;
			view.y = 0;
			view.setSize(400, 300);
			view.addScene(scene);
			addChild(view);
			view.addEventListener(MouseEvent.MOUSE_DOWN, viewMouseDown);
			view.addEventListener(MouseEvent.MOUSE_WHEEL, viewZoom);

			scene.render();
		}
		
		private var gt:GTween;
		
		private function grid_mouseHandler (evt:ProxyEvent):void
		{
			var mEvt:MouseEvent = MouseEvent(evt.targetEvent);
			var pt:Pt = new Pt(mEvt.localX, mEvt.localY);
			IsoMath.screenToIso(pt);
			
			if (gt)
				gt.end();
				
			else
			{
				gt = new GTween();
				gt.addEventListener(Event.COMPLETE, gt_completeHandler);
			}
			
			gt.target = box;
			gt.duration = 0.5;
			var squareSize:int = 25; // 
			var gridX:int = Math.floor( pt.x / squareSize );
			var gridY:int = Math.floor( pt.y / squareSize );
			gt.setValues( {x:gridX * squareSize, y:gridY * squareSize});
			gt.paused=false;
			if (!hasEventListener(Event.ENTER_FRAME))
				this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		private function gt_completeHandler (evt:Event):void
		{
			this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
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
		}
		private function viewMouseUp(e:Event)
		{
			view.removeEventListener(MouseEvent.MOUSE_MOVE, viewPan);
			view.removeEventListener(MouseEvent.MOUSE_UP, viewMouseUp);
		}
		private function viewZoom(e:MouseEvent)
		{
			if(e.delta > 0)
			{
				zoom +=  0.10;
			}
			if(e.delta < 0)
			{
				zoom -=  0.10;
			}
			view.currentZoom = zoom;
		}
		private function enterFrameHandler (evt:Event):void
		{
			scene.render();
		}
	}
}