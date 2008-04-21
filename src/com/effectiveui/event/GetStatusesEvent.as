package com.effectiveui.event
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	public class GetStatusesEvent extends CairngormEvent
	{
		public static const GET_STATUSES:String = "getstauses";
		
		public function GetStatusesEvent()
		{
			super(GET_STATUSES);
		}

	}
}