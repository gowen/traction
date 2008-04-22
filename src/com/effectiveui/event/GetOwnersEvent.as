package com.effectiveui.event
{
	import com.adobe.cairngorm.control.CairngormEvent;

	public class GetOwnersEvent extends CairngormEvent
	{
		public static const GET_OWNERS:String = "getowners";
		
		public function GetOwnersEvent()
		{
			super(GET_OWNERS);
		}
		
	}
}