package com.effectiveui.event
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	public class GetTicketsEvent extends CairngormEvent
	{
		public static const GET_ALL:String = "getalltickets";
		public static const GET_ACTIVE:String = "getactivetickets";
				
		public function GetTicketsEvent(type:String = null)
		{
			super(type);
		}

	}
}