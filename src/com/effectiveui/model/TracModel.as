package com.effectiveui
{
	import com.adobe.cairngorm.model.ModelLocator;
	
	import mx.collections.ArrayCollection;

	[Bindable]
	public class TracModel implements ModelLocator
	{		
		private static var model:TracModel;
		public static function getInstance():TracModel{
			if(model == null){
				model = new TracModel();
			}
			return model;
		}
		public function TracModel()
		{
			if ( model != null ){
				throw new Error("Only one EbayModelLocator instance should be instantiated");	
			}
		}
		
		public var username:String;
		public var password:String;
		public var serverURL:String;
		public var tickets:ArrayCollection;
		public var milestones:ArrayCollection;
		public var components:ArrayCollection;
		public var statuses:ArrayCollection;
		public var versions:ArrayCollection;
		public var priorities:ArrayCollection;
		public var resolutions:ArrayCollection;
	}
}