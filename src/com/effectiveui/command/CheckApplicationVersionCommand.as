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
	import com.effectiveui.component.ModalAlert;
	
	import flash.desktop.NativeApplication;
	import flash.display.DisplayObject;
	
	public class CheckApplicationVersionCommand implements Command
	{
		import com.adobe.cairngorm.commands.Command;
		import com.adobe.cairngorm.control.CairngormEvent;
		import com.effectiveui.model.TracModel;
		
		import flash.events.Event;
		import flash.events.IOErrorEvent;
		import flash.filesystem.File;
		import flash.filesystem.FileMode;
		import flash.filesystem.FileStream;
		import flash.net.URLLoader;
		import flash.net.URLLoaderDataFormat;
		import flash.net.URLRequest;
		import flash.desktop.Updater;
		import flash.utils.ByteArray;
		
		import mx.core.Application;
		import mx.core.Window;
		import mx.managers.PopUpManager;
		import com.effectiveui.util.IOUtil;

		public function execute(event:CairngormEvent):void {    
			checkLocalVersion();
		}
		
		private var localVersion:Array;
		private var localVersionString:String;
		private var onlineVersion:Array;
		private var onlineVersionString:String;
		private var onlineDescriptorXML:XML;
		private var updateURLDirectory:String = "http://traction.effectiveui.com/release/";
		private var onlineFileName:String;
		private var onlineUpdatePath:String;
		private function checkLocalVersion():void{
			//trace("checkLocalVersion");
			var descriptorXML:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var NS:Namespace = descriptorXML.namespace();
			localVersionString = descriptorXML.NS::version;
			//var str:String = localVersionString;
			TracModel.getInstance().appVersion = localVersionString;
			localVersion = localVersionString.split(".");
			checkOnlineVersion();
		}
		
		/* Get the latest version from the server */
		private function checkOnlineVersion():void{
			//trace("checkOnlineVersion");
			var url:String = updateURLDirectory+"release.xml";
			var alternateURLData:String = IOUtil.readTextFile(File.applicationStorageDirectory.resolvePath("updatePath.xml"));
			if(alternateURLData != null){
				url = new XML(alternateURLData);
			}
			var request:URLRequest = new URLRequest(url);
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, chooseUpdatePath);
			loader.addEventListener(IOErrorEvent.IO_ERROR, die);
			loader.load(request);
		}
		
		private function chooseUpdatePath(event:Event):void{
			//trace("parseOnlineVersion");
			try{
			    //get the latest version from the URLLoader
				if(event){
				    var loader:URLLoader = URLLoader(event.target);
				    onlineDescriptorXML = new XML(loader.data);
				    onlineVersionString = onlineDescriptorXML.version;
				} else {
				    onlineVersionString = "";
				}
				onlineFileName = onlineDescriptorXML.file;
				onlineUpdatePath = onlineDescriptorXML.path;
				onlineVersion = onlineVersionString.split(".");
				
				//now compare the online version to the latest file version, if any files are stored
			    //first get the latest file version
			    var latestFileVersion:Array = null;
			    var latestFileRef:File = null;
    			var updatedir:File = File.applicationStorageDirectory.resolvePath("updates/");
    			if(updatedir.isDirectory){
    				var list:Array = updatedir.getDirectoryListing().reverse(); //start at the bottom because in alpha-numeric order the latest will be last
    				for(var i:int = list.length-1; i>-1; i--){
    					var localFile:File = list[i];
    					if(!localFile.isHidden && !localFile.isDirectory){
    						var fileVersionString:String = extractVersionFromAirName(localFile.name);
    						trace(fileVersionString);
    						var fileVersionNumbers:Array = fileVersionString.split(".");
    						if(!latestFileVersion || isNewerVersion(fileVersionNumbers, latestFileVersion)){
    						    latestFileVersion = fileVersionNumbers;
    						    latestFileRef = localFile;
    						} else {
    						    localFile.deleteFile(); //if its not the latest version then it doesn't need to be there    						    
    						}													
    					}
    				}
    			}		
				
				if(onlineVersion && (!latestFileVersion || isNewerVersion(onlineVersion, latestFileVersion))){ //if the online version is newest
    				if(isNewerVersion(onlineVersion, localVersion)){ //and its newer than the installed version				
    					//download the new version, then install
    					trace("Downloading new version: " + onlineVersion.join('.'));
    					var request:URLRequest = new URLRequest();
    					request.url = onlineUpdatePath+onlineFileName;
    	        		var airloader:URLLoader = new URLLoader();
    	        		airloader.dataFormat = URLLoaderDataFormat.BINARY;
    	        		airloader.addEventListener(Event.COMPLETE, airDownloaded);
    	        		airloader.addEventListener(IOErrorEvent.IO_ERROR, die);
    	        		airloader.load(request);
    				}
                } else if(latestFileVersion && isNewerVersion(latestFileVersion, localVersion)){ //if the file is newer than local and same or newer than online            
			    	//then we update using the file
		    		trace("Installing update to version: " + latestFileVersion.join('.'));
			    	var updater:Updater = new Updater();
				    updater.update(latestFileRef, latestFileVersion.join("."));						
                } else if(updatedir.isDirectory){ //if neither is newer but the update dir exists then clean up the update dir
                    updatedir.deleteDirectory(true);
                    trace("Local version is up to date. Deleting update dir if it exists.");
                }
			}catch(e:Error){}
		}
						
		private function extractVersionFromAirName(str:String):String{
			var name:String = str.split(".")[0];
			var pieces:Array = name.split("_");
			var version:Array = [];
			for each (var piece:String in pieces){
				if(!isNaN(parseInt(piece))){
					version.push(piece);
				}
			}
			return version.join(".");
		}
	
		private function airDownloaded(event:Event):void{
			trace("new AIR file downloaded");
			var loader:URLLoader = URLLoader(event.target);
			//clean up any local files so they don't get in the way later
			var updatedir:File = File.applicationStorageDirectory.resolvePath("updates/");
			if(updatedir.isDirectory){
			    updatedir.deleteDirectory(true);
			}
			var filestore:File = File.applicationStorageDirectory.resolvePath("updates/"+onlineFileName);
			var writer:FileStream = new FileStream();
			writer.open(filestore, FileMode.WRITE);
			writer.writeBytes(loader.data, 0, ByteArray(loader.data).bytesAvailable);
			writer.close();
			//var parent:DisplayObject = Traction(Application.application).getOpenWindow();
			var parent:DisplayObject = Traction(Application.application);
            var alert:ModalAlert = new ModalAlert();
            alert.okButtonText = "Install Now";
            alert.cancelButtonText = "Later";
            alert.width = 430;
            alert.height = 190;
            alert.titleText = "Traction Update"
            alert.messageText = "Traction has found a new update and is ready to install. Please review the update below.\r\rCurrent Version: " + localVersionString + "\rNew Version: "+onlineVersionString+"\r\rBy choosing Install Now, Traction will be automatically restarted.";
            alert.addEventListener("okClicked", alertClickHandler);
            PopUpManager.addPopUp(alert, parent);
		}
		private function alertClickHandler(event:Event):void{
			chooseUpdatePath(null);			
		}
		private function die(event:*):void{
			trace(event);
		}
		
		public static function isNewerVersion(newVersion:Array, oldVersion:Array):Boolean{
		    //assume longer version strings are always more recent
		    if(oldVersion.length < newVersion.length){
		        return true;
		    } else if(oldVersion.length > newVersion.length){
		        return false;
		    }
		    //compare each number in the version strings
		    for(var i:int = 0; i < oldVersion.length; i++){
		        var newNum:int = parseInt(String(newVersion[i]));
		        var oldNum:int = parseInt(String(oldVersion[i]));
		        //for each level in the version string
		        if(newNum > oldNum){ //if the new version has a higher number than the old
		            return true; //then its newer
		        } else if(newNum < oldNum){ //if the old has a higher number than the new
		            return false; //then this is not a newer version
		        } //if they are equal then go to the next level in the version strings
		    }
		    
		    //if the version numbers are the same then we return false, this is not a newer version
		    return false;
		}
	}
}