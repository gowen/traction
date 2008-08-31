package com.effectiveui.util
{
	import com.effectiveui.component.TracTicket;
	import com.effectiveui.event.GetNewTicketsEvent;
	import com.effectiveui.model.TracModel;
	
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	
	public class IOUtil
	{		
		public static function addTicketToDB(ticket:TracTicket):void{
			var model:TracModel = TracModel.getInstance();
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = model.dbConnection;
			stmt.text = "INSERT OR REPLACE INTO tickets (id, summary, description, version, milestone, owner, resolution, component, priority, keywords, reporter, type, status) " + 
					"VALUES (:id, :summary, :description, :version, :milestone, :owner, :resolution, :component, :priority, :keywords, :reporter, :type, :status)";
			stmt.parameters[':id'] = ticket.id;
			stmt.parameters[':summary'] = ticket.summary;
			stmt.parameters[':description'] = ticket.description;
			stmt.parameters[':version'] = ticket.version;
			stmt.parameters[':milestone'] = ticket.milestone;
			stmt.parameters[':owner'] = ticket.owner;
			stmt.parameters[':resolution'] = ticket.resolution;
			stmt.parameters[':component'] = ticket.component;
			stmt.parameters[':priority'] = ticket.priority;
			stmt.parameters[':keywords'] = ticket.keywords;
			stmt.parameters[':reporter'] = ticket.reporter;
			stmt.parameters[':type'] = ticket.type;
			stmt.parameters[':status'] = ticket.status;
			
			stmt.execute();
		}
		
		public static function loadAllTickets():void{			
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = TracModel.getInstance().dbConnection;
			stmt.text = "SELECT * FROM tickets";
			stmt.addEventListener(SQLEvent.RESULT, handleTicketsLoaded);
			stmt.execute();
		}
		
		public static function loadOpenTickets():void{
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = TracModel.getInstance().dbConnection;
			stmt.text = "SELECT * FROM tickets WHERE status IS NOT 'closed'";
			stmt.addEventListener(SQLEvent.RESULT, handleTicketsLoaded);
			stmt.execute();
		}
		
		public static function loadClosedTickets():void{
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = TracModel.getInstance().dbConnection;
			stmt.text = "SELECT * FROM tickets WHERE status LIKE 'closed'";
			stmt.addEventListener(SQLEvent.RESULT, handleTicketsLoaded);
			stmt.execute();
		}
		
		protected static function handleTicketsLoaded(event:SQLEvent):void{			
			var model:TracModel = TracModel.getInstance();
			var results:SQLResult = SQLStatement(event.target).getResult();
			var sort:Sort = model.tickets.sort;
			var filter:Function = model.tickets.filterFunction;
			model.tickets = new ArrayCollection();
			model.tickets.sort = sort;
			model.tickets.filterFunction = filter;
			if(results && results.data && results.data.length > 0){
				model.tickets.disableAutoUpdate();
				for each (var row:Object in results.data){					
					model.tickets.addItem(ticketFromObject(row));
				}
			}
			model.tickets.enableAutoUpdate();
			model.tickets.refresh();
			// if this was a "load all" call then we set the model's count vars 
			if(SQLStatement(event.target).text.toLowerCase().indexOf("select * from tickets") != -1){
				model.ticketCount = model.tickets.length;
				model.numTicketsLoaded = model.tickets.length;
			}
			
			new GetNewTicketsEvent(model.dateToISO(model.currentTimeStamp)).dispatch(); //always run an update when we change working sets
		}
		
		public static function ticketFromObject(o:Object):TracTicket{
			var ticket:TracTicket = new TracTicket();
			ticket.id = o['id'];
			ticket.summary = o['summary'];
			ticket.description = o['description'];
			ticket.version = o['version'];
			ticket.milestone = o['milestone'];
			ticket.owner = o['owner'];
			ticket.resolution = o['resolution'];
			ticket.component = o['component'];
			ticket.priority = o['priority'];
			ticket.keywords = o['keywords'];
			ticket.reporter = o['reporter'];
			ticket.type = o['type'];
			ticket.status = o['status'];
			
			return ticket;
		}
		
		public static function saveTime(time:Number):void{
			var stream:FileStream = new FileStream();
			stream.open(File.applicationStorageDirectory.resolvePath(TracModel.getInstance().username).resolvePath('lastUpdated.dat'), FileMode.WRITE);
			stream.writeDouble(time);
		}
		
		public static function readTime():Number{
			var stream:FileStream = new FileStream();
			stream.open(File.applicationStorageDirectory.resolvePath(TracModel.getInstance().username).resolvePath('lastUpdated.dat'), FileMode.READ);
			var lastTime:Number = stream.readDouble();
			return lastTime;
		}
	}
}