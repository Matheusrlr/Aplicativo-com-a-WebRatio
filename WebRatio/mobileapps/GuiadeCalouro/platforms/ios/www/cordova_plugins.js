
cordova.define('cordova/plugin_list', function(require, exports, module) {
	
	module.exports = [
		
			{
				"file": "plugins/com.webratio.accountmanager/www\/accountmanager.js",
				"id": "com.webratio.accountmanager.accountmanager",
				"clobbers": [
					
						"window.accountmanager"
					
				],
				"merges": [
					
				]
				
			}
		,
			{
				"file": "plugins/cordova-plugin-device/www\/device.js",
				"id": "cordova-plugin-device.device",
				"clobbers": [
					
						"device"
					
				],
				"merges": [
					
				]
				
			}
		,
			{
				"file": "plugins/cordova-plugin-dialogs/www\/notification.js",
				"id": "cordova-plugin-dialogs.notification",
				"clobbers": [
					
				],
				"merges": [
					
						"navigator.notification"
					
				]
				
			}
		,
			{
				"file": "plugins/cordova-plugin-dialogs/www\/ios\/notification.js",
				"id": "cordova-plugin-dialogs.notification_ios",
				"clobbers": [
					
				],
				"merges": [
					
						"navigator.notification"
					
				]
				
			}
		,
			{
				"file": "plugins/cordova-plugin-file/www\/DirectoryEntry.js",
				"id": "cordova-plugin-file.DirectoryEntry",
				"clobbers": [
					
						"window.DirectoryEntry"
					
				],
				"merges": [
					
				]
				
			}
		,
			{
				"file": "plugins/cordova-plugin-file/www\/DirectoryReader.js",
				"id": "cordova-plugin-file.DirectoryReader",
				"clobbers": [
					
						"window.DirectoryReader"
					
				],
				"merges": [
					
				]
				
			}
		,
			{
				"file": "plugins/cordova-plugin-file/www\/Entry.js",
				"id": "cordova-plugin-file.Entry",
				"clobbers": [
					
						"window.Entry"
					
				],
				"merges": [
					
				]
				
			}
		,
			{
				"file": "plugins/cordova-plugin-file/www\/File.js",
				"id": "cordova-plugin-file.File",
				"clobbers": [
					
						"window.File"
					
				],
				"merges": [
					
				]
				
			}
		,
			{
				"file": "plugins/cordova-plugin-file/www\/FileEntry.js",
				"id": "cordova-plugin-file.FileEntry",
				"clobbers": [
					
						"window.FileEntry"
					
				],
				"merges": [
					
				]
				
			}
		,
			{
				"file": "plugins/cordova-plugin-file/www\/FileError.js",
				"id": "cordova-plugin-file.FileError",
				"clobbers": [
					
						"window.FileError"
					
				],
				"merges": [
					
				]
				
			}
		,
			{
				"file": "plugins/cordova-plugin-file/www\/FileReader.js",
				"id": "cordova-plugin-file.FileReader",
				"clobbers": [
					
						"window.FileReader"
					
				],
				"merges": [
					
				]
				
			}
		,
			{
				"file": "plugins/cordova-plugin-file/www\/FileSystem.js",
				"id": "cordova-plugin-file.FileSystem",
				"clobbers": [
					
						"window.FileSystem"
					
				],
				"merges": [
					
				]
				
			}
		,
			{
				"file": "plugins/cordova-plugin-file/www\/FileUploadOptions.js",
				"id": "cordova-plugin-file.FileUploadOptions",
				"clobbers": [
					
						"window.FileUploadOptions"
					
				],
				"merges": [
					
				]
				
			}
		,
			{
				"file": "plugins/cordova-plugin-file/www\/FileUploadResult.js",
				"id": "cordova-plugin-file.FileUploadResult",
				"clobbers": [
					
						"window.FileUploadResult"
					
				],
				"merges": [
					
				]
				
			}
		,
			{
				"file": "plugins/cordova-plugin-file/www\/FileWriter.js",
				"id": "cordova-plugin-file.FileWriter",
				"clobbers": [
					
						"window.FileWriter"
					
				],
				"merges": [
					
				]
				
			}
		,
			{
				"file": "plugins/cordova-plugin-file/www\/Flags.js",
				"id": "cordova-plugin-file.Flags",
				"clobbers": [
					
						"window.Flags"
					
				],
				"merges": [
					
				]
				
			}
		,
			{
				"file": "plugins/cordova-plugin-file/www\/LocalFileSystem.js",
				"id": "cordova-plugin-file.LocalFileSystem",
				"clobbers": [
					
						"window.LocalFileSystem"
					
				],
				"merges": [
					
						"window"
					
				]
				
			}
		,
			{
				"file": "plugins/cordova-plugin-file/www\/Metadata.js",
				"id": "cordova-plugin-file.Metadata",
				"clobbers": [
					
						"window.Metadata"
					
				],
				"merges": [
					
				]
				
			}
		,
			{
				"file": "plugins/cordova-plugin-file/www\/ProgressEvent.js",
				"id": "cordova-plugin-file.ProgressEvent",
				"clobbers": [
					
						"window.ProgressEvent"
					
				],
				"merges": [
					
				]
				
			}
		,
			{
				"file": "plugins/cordova-plugin-file/www\/fileSystems.js",
				"id": "cordova-plugin-file.fileSystems",
				"clobbers": [
					
				],
				"merges": [
					
				]
				
			}
		,
			{
				"file": "plugins/cordova-plugin-file/www\/requestFileSystem.js",
				"id": "cordova-plugin-file.requestFileSystem",
				"clobbers": [
					
						"window.requestFileSystem"
					
				],
				"merges": [
					
				]
				
			}
		,
			{
				"file": "plugins/cordova-plugin-file/www\/resolveLocalFileSystemURI.js",
				"id": "cordova-plugin-file.resolveLocalFileSystemURI",
				"clobbers": [
					
				],
				"merges": [
					
						"window"
					
				]
				
			}
		,
			{
				"file": "plugins/cordova-plugin-file/www\/browser\/isChrome.js",
				"id": "cordova-plugin-file.isChrome",
				"clobbers": [
					
				],
				"merges": [
					
				]
				,
					"runs": true
				
			}
		,
			{
				"file": "plugins/cordova-plugin-file/www\/ios\/FileSystem.js",
				"id": "cordova-plugin-file.iosFileSystem",
				"clobbers": [
					
				],
				"merges": [
					
						"FileSystem"
					
				]
				
			}
		,
			{
				"file": "plugins/cordova-plugin-file/www\/fileSystems-roots.js",
				"id": "cordova-plugin-file.fileSystems-roots",
				"clobbers": [
					
				],
				"merges": [
					
				]
				,
					"runs": true
				
			}
		,
			{
				"file": "plugins/cordova-plugin-file/www\/fileSystemPaths.js",
				"id": "cordova-plugin-file.fileSystemPaths",
				"clobbers": [
					
				],
				"merges": [
					
						"cordova"
					
				]
				,
					"runs": true
				
			}
		,
			{
				"file": "plugins/cordova-plugin-file-transfer/www\/FileTransferError.js",
				"id": "cordova-plugin-file-transfer.FileTransferError",
				"clobbers": [
					
						"window.FileTransferError"
					
				],
				"merges": [
					
				]
				
			}
		,
			{
				"file": "plugins/cordova-plugin-file-transfer/www\/FileTransfer.js",
				"id": "cordova-plugin-file-transfer.FileTransfer",
				"clobbers": [
					
						"window.FileTransfer"
					
				],
				"merges": [
					
				]
				
			}
		,
			{
				"file": "plugins/cordova-plugin-globalization/www\/GlobalizationError.js",
				"id": "cordova-plugin-globalization.GlobalizationError",
				"clobbers": [
					
						"window.GlobalizationError"
					
				],
				"merges": [
					
				]
				
			}
		,
			{
				"file": "plugins/cordova-plugin-globalization/www\/globalization.js",
				"id": "cordova-plugin-globalization.globalization",
				"clobbers": [
					
						"navigator.globalization"
					
				],
				"merges": [
					
				]
				
			}
		,
			{
				"file": "plugins/cordova-plugin-inappbrowser/www\/inappbrowser.js",
				"id": "cordova-plugin-inappbrowser.inappbrowser",
				"clobbers": [
					
						"cordova.InAppBrowser.open"
					,
						"window.open"
					
				],
				"merges": [
					
				]
				
			}
		,
			{
				"file": "plugins/cordova-plugin-ionic-webview/src\/www\/ios\/ios-wkwebview-exec.js",
				"id": "cordova-plugin-ionic-webview.ios-wkwebview-exec",
				"clobbers": [
					
						"cordova.exec"
					
				],
				"merges": [
					
				]
				
			}
		,
			{
				"file": "plugins/cordova-plugin-network-information/www\/network.js",
				"id": "cordova-plugin-network-information.network",
				"clobbers": [
					
						"navigator.connection"
					,
						"navigator.network.connection"
					
				],
				"merges": [
					
				]
				
			}
		,
			{
				"file": "plugins/cordova-plugin-network-information/www\/Connection.js",
				"id": "cordova-plugin-network-information.Connection",
				"clobbers": [
					
						"Connection"
					
				],
				"merges": [
					
				]
				
			}
		,
			{
				"file": "plugins/cordova-plugin-splashscreen/www\/splashscreen.js",
				"id": "cordova-plugin-splashscreen.SplashScreen",
				"clobbers": [
					
						"navigator.splashscreen"
					
				],
				"merges": [
					
				]
				
			}
		,
			{
				"file": "plugins/ionic-plugin-keyboard/www\/ios\/keyboard.js",
				"id": "ionic-plugin-keyboard.keyboard",
				"clobbers": [
					
						"cordova.plugins.Keyboard"
					
				],
				"merges": [
					
				]
				,
					"runs": true
				
			}
		
	];
	
	module.exports.metadata = {
		
			"com.webratio.accountmanager": "1.1.6"
		,
			"cordova-plugin-device": "2.0.1"
		,
			"cordova-plugin-dialogs": "2.0.1.1wr"
		,
			"cordova-plugin-file": "5.0.0.3wr"
		,
			"cordova-plugin-file-transfer": "1.7.0"
		,
			"cordova-plugin-globalization": "1.0.9"
		,
			"cordova-plugin-inappbrowser": "2.0.1"
		,
			"cordova-plugin-ionic-webview": "1.1.19.2wr"
		,
			"cordova-plugin-network-information": "2.0.1"
		,
			"cordova-plugin-splashscreen": "5.0.1"
		,
			"cordova-plugin-websql": "0.0.10.6wr"
		,
			"cordova-plugin-whitelist": "1.3.3"
		,
			"ionic-plugin-keyboard": "2.2.1.1wr"
		
	};
	
});