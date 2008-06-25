// ActionScript file
package com.effectiveui.event
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	public class GetScoresEvent extends CairngormEvent
	{
		public static const GET_SCORES:String = "getscores";	
	
		public function GetScoresEvent(){		
			super(GET_SCORES);
		}

	}
}