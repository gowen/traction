package com.effectiveui.component
{
	[Bindable]
	public class TracTicket
	{
		public var id:String = ""; //not returned in the ticket object from XML-RPC, but returned in the getTicket() call
		
		public var summary:String = "";
		public var version:String = "";
		public var milestone:String = "";
		public var owner:String = "";
		public var resolution:String = "";
		public var component:String = "";
		public var priority:String = "";
		public var keywords:String = "";
		public var reporter:String = "";
		public var type:String = "";
		public var status:String = "";
		public var description:String = "";
		
		public function getFromTicketObject(obj:Object):void{
			if(obj.summary){
				summary = obj.summary;
			}
			if(obj.version){
				version = obj.version;
			}
			if(obj.milestone){
				milestone = obj.milestone;
			}
			if(obj.owner){
				owner = obj.owner;
			}
			if(obj.resolution){
				resolution = obj.resolution;
			}
			if(obj.component){
				component = obj.component
			}
			if(obj.priority){
				priority = obj.priority;
			}
			if(obj.keywords){
				keywords = obj.keywords;
			}
			if(obj.reporter){
				reporter = obj.reporter;
			}
			if(obj.type){
				type = obj.type;
			}
			if(obj.status){
				status = obj.status;
			}
			if(obj.description){
				description = obj.description;
			}
		}
		
		public function toObject():Object{
			var ticket:Object = new Object();
			ticket.summary = summary;
			ticket.version = version;
			ticket.milestone = milestone;
			ticket.owner = owner;
			ticket.resolution = resolution;
			ticket.component = component;
			ticket.priority = priority;
			ticket.keywords = keywords;
			ticket.reporter = reporter;
			ticket.type = type;
			ticket.status = status;
			ticket.description = description;
			return ticket;
		}											
	}
}