package com.effectiveui.event
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	public class GetComponentsEvent extends CairngormEvent
	{
		public static const GET_COMPONENTS:String = "getcomponents";	
	
		public function GetComponentsEvent(){		
			super(GET_COMPONENTS);
		}

	}
}