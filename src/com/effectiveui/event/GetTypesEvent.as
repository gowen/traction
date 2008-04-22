package com.effectiveui.event
{
	import com.adobe.cairngorm.control.CairngormEvent;

	public class GetTypesEvent extends CairngormEvent
	{
		public static const GET_TYPES:String = "gettypes";
		public function GetTypesEvent()
		{
			super(GET_TYPES);
		}
		
	}
}