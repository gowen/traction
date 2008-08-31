package com.effectiveui.command
{
	import com.adobe.cairngorm.commands.Command;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.effectiveui.model.TracModel;
	
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.events.SQLEvent;

	public class GetOwnersCommand implements Command
	{
		protected var model:TracModel = TracModel.getInstance();
	
		public function execute(event:CairngormEvent):void{
			if(!model.dbConnection || !model.dbConnection.connected){
				return;
			}
			
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = model.dbConnection;
			stmt.text = "SELECT DISTINCT owner FROM tickets";
			stmt.addEventListener(SQLEvent.RESULT, handleSQLReturn);
			stmt.execute();
		}
		
		public function handleSQLReturn(event:SQLEvent):void{
			var results:SQLResult = SQLStatement(event.target).getResult();
			if(results && results.data && results.data.length > 0){
				for each (var entry:Object in results.data){
					if(!model.owners.contains(entry.owner)){
						model.owners.addItem(entry.owner);
					}
				}
			}
		}
	
	/*	protected var conn:ConnectionImpl;
		public function execute(event:CairngormEvent):void{		
			conn = new ConnectionImpl(model.serverURL, model.username, model.password);
			conn.addParam("CurrentUsers", XMLRPCDataTypes.STRING);
			conn.addEventListener(Event.COMPLETE, handleOwnersReturn);
			conn.call("wiki.getPage");
		}
		
		protected function handleOwnersReturn(event:Event):void{
			model.owners.removeAll();
			model.owners.addItem(model.NO_VALUE);
			var owners:Array = (conn.getResponse() as String).split("\r\n");
			for each(var owner:String in owners){
				model.owners.addItem(owner);
				
				var scoreCard:Object = new Object();
				scoreCard["owner"] = owner;
				scoreCard["score"] = 0;
				model.scoreBoard.addItem(scoreCard);
			}
			if(!model.owners.contains(model.username)){
				model.owners.addItem(model.username);
			}
		}*/
	}
}