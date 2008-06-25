package assets
{
	import mx.skins.ProgrammaticSkin;
	import flash.display.Graphics;

	public class headerSeperatorSkin extends ProgrammaticSkin
	{
		public function headerSeperatorSkin()
		{
			super();
		}
		
		override public function get measuredWidth():Number {
	      return 1;
	    }
	 
	    override public function get measuredHeight():Number {
	      return 10;
	    }
	 
	    override protected  function updateDisplayList(w:Number, h:Number):void {
	      var borderColor:uint = getStyle("borderColor");
	      var g:Graphics = graphics;
	      g.moveTo(1,0);
	      g.lineStyle(1,borderColor);
	      g.lineTo(1,h);
		}
	}
}