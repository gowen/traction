package com.effectiveui.event
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	public class GetVersionsEvent extends CairngormEvent
	{
		public static const GET_VERSIONS:String = "getversions";
		
		public function GetVersionsEvent()
		{
			super(GET_VERSIONS);
		}

	}
}