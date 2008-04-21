package com.effectiveui.event
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	public class GetResolutionsEvent extends CairngormEvent
	{
		public static const GET_RESOLUTIONS:String = "getresolutions";
		
		public function GetResolutionsEvent()
		{
			super(GET_RESOLUTIONS);
		}

	}
}