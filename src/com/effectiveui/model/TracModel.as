package com.effectiveui.model
{
	import com.adobe.cairngorm.model.ModelLocator;
	
	import mx.collections.ArrayCollection;

	[Bindable]
	public class TracModel implements ModelLocator
	{		
		private static var _model:TracModel;
		public static function getInstance():TracModel{
			if(_model == null){
				_model = new TracModel();
			}
			return _model;
		}
		public function TracModel()
		{
			if ( _model != null ){
				throw new Error("Only one EbayModelLocator instance should be instantiated");	
			}			
		}
		
		public function getURL():String{
			return "https://" + username + ":" + password + "@" + serverURL + "/login/xmlrpc";
		}
		
		public var username:String;
		public var password:String;
		public var serverURL:String;
		public var tickets:ArrayCollection = new ArrayCollection();
		public var milestones:ArrayCollection = new ArrayCollection();
		public var components:ArrayCollection = new ArrayCollection();
		public var statuses:ArrayCollection = new ArrayCollection();
		public var versions:ArrayCollection = new ArrayCollection();
		public var priorities:ArrayCollection = new ArrayCollection();
		public var resolutions:ArrayCollection = new ArrayCollection();
		public var types:ArrayCollection = new ArrayCollection();
		public var ticketsLoaded:Boolean = false;
		
		public const NO_VALUE:String = "";
	}
	
	
}