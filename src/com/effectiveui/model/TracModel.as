package com.effectiveui.model
{
	import com.adobe.cairngorm.model.ModelLocator;
	import com.effectiveui.component.TracTicket;
	
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
				throw new Error("Only one TracModel instance should be instantiated");	
			}			
		}
		
		//converts the current date timestamp to an .Iso86 format
		public function dateToISO():String {
			var d:Date = new Date();
	        var iso:String = d.getUTCFullYear() +
	                ((d.getUTCMonth()+1 < 10)?'0':'') + (d.getUTCMonth()+1) +
	                ((d.getUTCDate() < 10)?'0':'') + d.getUTCDate()+'T'+
	                ((d.getUTCHours()< 10)?'0':'') + d.getUTCHours() +':'+
	                ((d.getUTCMinutes()< 10)?'0':'') + d.getUTCMinutes() +':'+
	                ((d.getUTCSeconds()< 10)?'0':'') + d.getUTCSeconds();
        	iso = iso.substring(0, iso.length-0);
        	return iso;
    	}
		
		public var username:String;
		public var password:String;
		public var serverURL:String;
		public var currentTicket:TracTicket = new TracTicket();
		public var currentViewTicket:TracTicket = new TracTicket();
		public var tickets:ArrayCollection = new ArrayCollection();
		public var milestones:ArrayCollection = new ArrayCollection();
		public var components:ArrayCollection = new ArrayCollection();
		public var statuses:ArrayCollection = new ArrayCollection();
		public var versions:ArrayCollection = new ArrayCollection();
		public var priorities:ArrayCollection = new ArrayCollection();
		public var resolutions:ArrayCollection = new ArrayCollection();
		public var types:ArrayCollection = new ArrayCollection();
		public var owners:ArrayCollection = new ArrayCollection();
		public var ticketsLoaded:Boolean = false;
		public var ticketCount:Number;
		public var numTicketsLoaded:Number = 0;;
		public var loggedIn:Boolean = false;
		public var currentTimeStamp:String = dateToISO();
		public var themes:Array = ["blue", "green", "orange", "pink", "silver"];
		
		public var scoreBoard:ArrayCollection = new ArrayCollection();
		
		public const NO_VALUE:String = "";
		
		
	}
	
	
}