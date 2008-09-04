/*
	Copyright 2008 Greg Owen, Phil Owen, Jacob Henry
	
	Website: http://github.com/gowen/traction 

    This file is part of Traction.

    Traction is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    any later version.

    Traction is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Traction.  If not, see <http://www.gnu.org/licenses/>.

*/
package com.effectiveui.skins
{
	import mx.skins.ProgrammaticSkin;
	import flash.display.Graphics;

	public class TracHeaderSeperatorSkin extends ProgrammaticSkin
	{
		public function TracHeaderSeperatorSkin()
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