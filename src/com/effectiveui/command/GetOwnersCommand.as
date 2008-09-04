/*
	Copyright 2008 Greg Owen, Phil Owen, Jacob Henry
	
	Website: http://github.com/gowen/traction 

    This file is part of Traction.

    Traction is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    any later version.

    Traction is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Traction.  If not, see <http://www.gnu.org/licenses/>.

*/
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
		public static const ALL_OWNERS:String = "All Owners";
	
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
			if(model.owners.length <= 0 || model.owners.getItemAt(0).toString() != ALL_OWNERS){
				model.owners.addItemAt(ALL_OWNERS, 0);
			}
			var results:SQLResult = SQLStatement(event.target).getResult();
			if(results && results.data && results.data.length > 0){
				for each (var entry:Object in results.data){
					if(!model.owners.contains(entry.owner)){
						model.owners.addItem(entry.owner);
					}
					var scoreCard:Object = new Object();
                   	scoreCard["owner"] = entry.owner;
					scoreCard["score"] = 0;
					model.scoreBoard.addItem(scoreCard);
				}
			}			
		}
	}
}