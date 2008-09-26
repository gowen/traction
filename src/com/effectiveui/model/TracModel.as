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
package com.effectiveui.model
{
	import com.adobe.cairngorm.model.ModelLocator;
	import com.effectiveui.component.TracTicket;
	
	import flash.data.SQLConnection;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
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
		public function dateToISO(time:Number = NaN):String {
			var d:Date;
			if(isNaN(time)){
				d = new Date();
			} else {
				d = new Date(time);
			}
	        var iso:String = d.getUTCFullYear() +
	                ((d.getUTCMonth()+1 < 10)?'0':'') + (d.getUTCMonth()+1) +
	                ((d.getUTCDate() < 10)?'0':'') + d.getUTCDate()+'T'+
	                ((d.getUTCHours()< 10)?'0':'') + d.getUTCHours() +':'+
	                ((d.getUTCMinutes()< 10)?'0':'') + d.getUTCMinutes() +':'+
	                ((d.getUTCSeconds()< 10)?'0':'') + d.getUTCSeconds();
        	iso = iso.substring(0, iso.length-0);
        	return iso;        	
    	}
    	
    	public var appVersion:String; //the version of the installed application
		
		public var username:String;
		public var password:String;
		public var serverURL:String;
		public var projectName:String; //the name of the project based on the URL
		public var projectPath:String; //the path to the project within appStorage currently its username/projectName
		public var currentTicket:TracTicket = new TracTicket();
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
		public var ticketCount:Number = 0;
		public var numTicketsLoaded:Number = 0;;
		public var loggedIn:Boolean = false;
		public var currentTimeStamp:Number;
		public var themes:Array = ["blue", "green", "orange", "pink", "silver"];
		public var updating:Boolean = false; //indicates whether the app is currently updating its ticket base
		public var sendingData:Boolean = false; //indicates whether the app is currently sending data to the server
		public static const MINUTE:Number = 1000*60;
		public var updateTime:Number = 2 * MINUTE;
		public var updateTimer:Timer = new Timer(updateTime);
		
		public var scoreBoard:ArrayCollection = new ArrayCollection();
		
		public const NO_VALUE:String = "";
		
		public var sync:Boolean = false; //indicates whether we are keeping the local copy in sync with the server
		public var dbConnection:SQLConnection;
		public var firstSync:Boolean = false; //indicates whether we are currently syncing for the first time
		
		public var currStatusSet:String = ""; //indicates the current status set that is selected: all, open, or closed 
	}
	
	
}