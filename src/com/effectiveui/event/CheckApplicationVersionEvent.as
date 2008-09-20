package com.effectiveui.event
{
	import com.adobe.cairngorm.control.CairngormEvent;

	public class CheckApplicationVersionEvent extends CairngormEvent
	{
		public static const CHECK_VERSION:String = "checkversion";
		
		public function CheckApplicationVersionEvent(type:String=CHECK_VERSION, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}