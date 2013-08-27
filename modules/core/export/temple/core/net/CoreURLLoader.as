/*
 *	Temple Library for ActionScript 3.0
 *	Copyright © MediaMonks B.V.
 *	All rights reserved.
 *	
 *	Redistribution and use in source and binary forms, with or without
 *	modification, are permitted provided that the following conditions are met:
 *	1. Redistributions of source code must retain the above copyright
 *	   notice, this list of conditions and the following disclaimer.
 *	2. Redistributions in binary form must reproduce the above copyright
 *	   notice, this list of conditions and the following disclaimer in the
 *	   documentation and/or other materials provided with the distribution.
 *	3. All advertising materials mentioning features or use of this software
 *	   must display the following acknowledgement:
 *	   This product includes software developed by MediaMonks B.V.
 *	4. Neither the name of MediaMonks B.V. nor the
 *	   names of its contributors may be used to endorse or promote products
 *	   derived from this software without specific prior written permission.
 *	
 *	THIS SOFTWARE IS PROVIDED BY MEDIAMONKS B.V. ''AS IS'' AND ANY
 *	EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 *	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 *	DISCLAIMED. IN NO EVENT SHALL MEDIAMONKS B.V. BE LIABLE FOR ANY
 *	DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 *	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 *	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 *	ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 *	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 *	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *	
 *	
 *	Note: This license does not apply to 3rd party classes inside the Temple
 *	repository with their own license!
 */

package temple.core.net 
{
	import temple.core.debug.IDebuggable;
	import temple.core.debug.Registry;
	import temple.core.debug.log.Log;
	import temple.core.debug.log.LogLevel;
	import temple.core.debug.objectToString;
	import temple.core.destruction.DestructEvent;
	import temple.core.destruction.IDestructibleOnError;
	import temple.core.events.EventListenerManager;
	import temple.core.templelibrary;

	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	/**
	 * @eventType temple.core.destruction.DestructEvent.DESTRUCT
	 */
	[Event(name = "DestructEvent.destruct", type = "temple.core.destruction.DestructEvent")]
	
	/**
	 * Base class for all URLLoaders in the Temple. The CoreURLLoader handles some core features of the Temple:
	 * <ul>
	 * 	<li>Registration to the Registry class.</li>
	 * 	<li>Event dispatch optimization.</li>
	 * 	<li>Easy remove of all EventListeners.</li>
	 * 	<li>Wrapper for Log class for easy logging.</li>
	 * 	<li>Completely destructible.</li>
	 * 	<li>Tracked in Memory (of this feature is enabled).</li>
	 * 	<li>Logs IOErrorEvents and SecurityErrorEvents.</li>
	 * </ul>
	 * 
	 * <p>You should always use and/or extend the CoreURLLoader instead of URLLoader if you want to make use of the Temple features.</p>
	 * 
	 * @see temple.core.Temple#registerObjectsInMemory
	 * 
	 * @author Thijs Broerse
	 */
	public class CoreURLLoader extends URLLoader implements ICoreLoader, IDestructibleOnError, IDebuggable
	{
		/**
		 * The current version of the Temple Library
		 */
		templelibrary static const VERSION:String = "3.6.0";
		
		/**
		 * @private
		 * 
		 * Protected namespace for construct method. This makes overriding of constructor possible.
		 */
		protected namespace construct;
		
		private const _toStringProps:Vector.<String> = Vector.<String>(['url']);
		private var _registryId:uint;
		private var _eventListenerManager:EventListenerManager;
		private var _isDestructed:Boolean;
		private var _destructOnError:Boolean;
		private var _isLoading:Boolean;
		private var _isLoaded:Boolean;
		private var _logErrors:Boolean;
		private var _url:String;
		private var _emptyPropsInToString:Boolean = true;
		private var _debug:Boolean;

		/**
		 * Creates a CoreURLLoader.
		 * 
		 * @param request optional <code>URLRequest</code> to load
		 * @param dataFormat Controls whether the downloaded data is received as text
		 * 	(<code>URLLoaderDataFormat.TEXT</code>), raw binary data (<code>URLLoaderDataFormat.BINARY</code>), or
		 * 	URL-encoded variables (<code>URLLoaderDataFormat.VARIABLES</code>).
		 * @param destructOnError if set to true (default) this object wil automatically be destructed on an Error
		 * 	(<code>IOError</code> or <code>SecurityError</code>)
		 * @param logErrors if set to true an error message wil be logged on an Error (<code>IOError</code> or 
		 * 	<code>SecurityError</code>)
		 */
		public function CoreURLLoader(request:URLRequest = null, dataFormat:String = "text", destructOnError:Boolean = true, logErrors:Boolean = true)
		{
			construct::coreURLLoader(request, dataFormat, destructOnError, logErrors);
			
			super(request);
			
			this.dataFormat = dataFormat;
		}
		
		/**
		 * @private
		 */
		construct function coreURLLoader(request:URLRequest, dataFormat:String, destructOnError:Boolean, logErrors:Boolean):void
		{
			_destructOnError = destructOnError;
			_logErrors = logErrors;
			
			_registryId = Registry.add(this);
			
			// Add default listeners to Error events and preloader support
			super.addEventListener(ProgressEvent.PROGRESS, handleProgress);
			super.addEventListener(Event.COMPLETE, handleComplete);
			super.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
			super.addEventListener(IOErrorEvent.DISK_ERROR, handleIOError);
			super.addEventListener(IOErrorEvent.NETWORK_ERROR, handleIOError);
			super.addEventListener(IOErrorEvent.VERIFY_ERROR, handleIOError);
			super.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
			
			request;
			dataFormat;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function load(request:URLRequest):void
		{
			if (_isDestructed)
			{
				logWarn("load: This object is destructed (probably because 'desctructOnErrors' is set to true, so it cannot load anything");
				return;
			}
			if (_debug) logDebug("load: " + request.url);
			
			_url = request.url;
			_isLoading = true;
			_isLoaded = false;
			super.load(request);
		}

		/**
		 * @inheritDoc
		 * 
		 * Checks if the object is actually loading before call super.unload();
		 */ 
		override public function close():void
		{
			if (_isLoading)
			{
				super.close();
				
				_isLoading = false;
				_url = null;
			}
			else if (_debug) logInfo('Nothing is loading, so closing is useless');
		}
		
		
		/**
		 * @inheritDoc
		 */
		public function get destructOnError():Boolean
		{
			return _destructOnError;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set destructOnError(value:Boolean):void
		{
			_destructOnError = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get isLoading():Boolean
		{
			return _isLoading;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get isLoaded():Boolean
		{
			return _isLoaded;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get url():String
		{
			return _url;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get logErrors():Boolean
		{
			return _logErrors;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set logErrors(value:Boolean):void
		{
			_logErrors = value;
		}
		
		[Temple]
		/**
		 * @inheritDoc
		 */
		public final function get registryId():uint
		{
			return _registryId;
		}
		
		/**
		 * @inheritDoc
		 * 
		 * Checks if this object has event listeners of this event before dispatching the event. Should speed up the
		 * application.
		 */
		override public function dispatchEvent(event:Event):Boolean 
		{
			if (hasEventListener(event.type) || event.bubbles) 
			{
				return super.dispatchEvent(event);
			}
			return true;
		}

		/**
		 * @inheritDoc
		 */
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void 
		{
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			if (getEventListenerManager()) _eventListenerManager.templelibrary::addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		/**
		 * @inheritDoc
		 */
		public function addEventListenerOnce(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0):void
		{
			if (getEventListenerManager()) _eventListenerManager.addEventListenerOnce(type, listener, useCapture, priority);
		}

		/**
		 * @inheritDoc
		 */
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void 
		{
			super.removeEventListener(type, listener, useCapture);
			if (_eventListenerManager) _eventListenerManager.templelibrary::removeEventListener(type, listener, useCapture);
		}

		/**
		 * @inheritDoc
		 */
		public function removeAllStrongEventListenersForType(type:String):void 
		{
			if (_eventListenerManager) _eventListenerManager.removeAllStrongEventListenersForType(type);
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeAllOnceEventListenersForType(type:String):void
		{
			if (_eventListenerManager) _eventListenerManager.removeAllOnceEventListenersForType(type);
		}

		/**
		 * @inheritDoc
		 */
		public function removeAllStrongEventListenersForListener(listener:Function):void 
		{
			if (_eventListenerManager) _eventListenerManager.removeAllStrongEventListenersForListener(listener);
		}

		/**
		 * @inheritDoc
		 */
		public function removeAllEventListeners():void 
		{
			if (_eventListenerManager) _eventListenerManager.removeAllEventListeners();
		}
		
		/**
		 * @inheritDoc
		 */
		public function listenTo(dispatcher:IEventDispatcher, type:String, listener:Function, useCapture:Boolean = false, priority:int = 0):void
		{
			if (getEventListenerManager()) _eventListenerManager.listenTo(dispatcher, type, listener, useCapture, priority);
		}
		
		/**
		 * @inheritDoc
		 */
		public function listenOnceTo(dispatcher:IEventDispatcher, type:String, listener:Function, useCapture:Boolean = false, priority:int = 0):void
		{
			if (getEventListenerManager()) _eventListenerManager.listenOnceTo(dispatcher, type, listener, useCapture, priority);
		}
		
		[Temple]
		/**
		 * @inheritDoc
		 */
		public function get eventListenerManager():EventListenerManager
		{
			return _eventListenerManager;
		}
		
		private function getEventListenerManager():EventListenerManager
		{
			if (_isDestructed)
			{
				logError("Object is destructed, don't add event listeners");
				return null;
			}
			return _eventListenerManager ||= EventListenerManager.getInstance(this) || new EventListenerManager(this);
		}

		/**
		 * @inheritDoc
		 */
		public function get debug():Boolean
		{
			return _debug;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set debug(value:Boolean):void
		{
			_debug = value;
		}

		/**
		 * Does a Log.debug, but has already filled in some known data.
		 * @param data the data to be logged
		 * 
		 * @see temple.core.debug.log.Log#debug()
		 * @see temple.core.debug.log.LogLevel#DEBUG
		 */
		protected final function logDebug(data:*):void
		{
			Log.templelibrary::send(data, toString(), LogLevel.DEBUG, _registryId);
		}
		
		/**
		 * Does a Log.error, but has already filled in some known data.
		 * @param data the data to be logged
		 * 
		 * @see temple.core.debug.log.Log#error()
		 * @see temple.core.debug.log.LogLevel#ERROR
		 */
		protected final function logError(data:*):void
		{
			Log.templelibrary::send(data, toString(), LogLevel.ERROR, _registryId);
		}
		
		/**
		 * Does a Log.fatal, but has already filled in some known data.
		 * @param data the data to be logged
		 * 
		 * @see temple.core.debug.log.Log#fatal()
		 * @see temple.core.debug.log.LogLevel#FATAL
		 */
		protected final function logFatal(data:*):void
		{
			Log.templelibrary::send(data, toString(), LogLevel.FATAL, _registryId);
		}
		
		/**
		 * Does a Log.info, but has already filled in some known data.
		 * @param data the data to be logged
		 * 
		 * @see temple.core.debug.log.Log#info()
		 * @see temple.core.debug.log.LogLevel#INFO
		 */
		protected final function logInfo(data:*):void
		{
			Log.templelibrary::send(data, toString(), LogLevel.INFO, _registryId);
		}
		
		/**
		 * Does a Log.status, but has already filled in some known data.
		 * @param data the data to be logged
		 * 
		 * @see temple.core.debug.log.Log#status()
		 * @see temple.core.debug.log.LogLevel#STATUS
		 */
		protected final function logStatus(data:*):void
		{
			Log.templelibrary::send(data, toString(), LogLevel.STATUS, _registryId);
		}
		
		/**
		 * Does a Log.warn, but has already filled in some known data.
		 * @param data the data to be logged
		 * 
		 * @see temple.core.debug.log.Log#warn()
		 * @see temple.core.debug.log.LogLevel#WARN
		 */
		protected final function logWarn(data:*):void
		{
			Log.templelibrary::send(data, toString(), LogLevel.WARN, _registryId);
		}
		
		/**
		 * List of property names which are output in the toString() method.
		 */
		protected final function get toStringProps():Vector.<String>
		{
			return _toStringProps;
		}
		
		/**
		 * @private
		 *
		 * Possibility to modify the toStringProps array from outside, using the templelibrary namespace.
		 */
		templelibrary final function get toStringProps():Vector.<String>
		{
			return _toStringProps;
		}
		
		/**
		 * A Boolean which indicates if empty properties are output in the toString() method.
		 */
		protected final function get emptyPropsInToString():Boolean
		{
			return _emptyPropsInToString;
		}

		/**
		 * @private
		 */
		protected final function set emptyPropsInToString(value:Boolean):void
		{
			_emptyPropsInToString = value;
		}

		/**
		 * @private
		 * 
		 * Possibility to modify the emptyPropsInToString value from outside, using the templelibrary namespace.
		 */
		templelibrary final function get emptyPropsInToString():Boolean
		{
			return _emptyPropsInToString;
		}
		
		/**
		 * @private
		 */
		templelibrary final function set emptyPropsInToString(value:Boolean):void
		{
			_emptyPropsInToString = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function toString():String
		{
			return objectToString(this, toStringProps, !emptyPropsInToString);
		}
		
		private function handleProgress(event:ProgressEvent):void
		{
			if (_debug) logDebug("handleProgress: " + Math.round(100 * (event.bytesLoaded / event.bytesTotal)) + "%, loaded: " + event.bytesLoaded + ", total: " + event.bytesTotal);
		}
		
		private function handleComplete(event:Event):void
		{
			if (_debug) logDebug("handleComplete");
			_isLoading = false;
			_isLoaded = true;
		}
		
		/**
		 * Default IOError handler
		 * 
		 * <p>If logErrors is set to true, an error message is logged</p>
		 */
		private function handleIOError(event:IOErrorEvent):void
		{
			_isLoading = false;
			if (_logErrors) logError(event.type + ': ' + event.text);
			if (_destructOnError) destruct();
		}
		
		/**
		 * Default SecurityError handler
		 * 
		 * <p>If logErrors is set to true, an error message is logged</p>
		 */
		private function handleSecurityError(event:SecurityErrorEvent):void
		{
			_isLoading = false;
			if (_logErrors) logError(event.type + ': ' + event.text);
			if (_destructOnError) destruct();
		}
		
		[Temple]
		/**
		 * @inheritDoc
		 */
		public final function get isDestructed():Boolean
		{
			return _isDestructed;
		}

		/**
		 * @inheritDoc
		 */
		public function destruct():void 
		{
			if (_isDestructed) return;
			
			dispatchEvent(new DestructEvent(DestructEvent.DESTRUCT));
			
			super.removeEventListener(ProgressEvent.PROGRESS, handleProgress);
			super.removeEventListener(Event.COMPLETE, handleComplete);
			super.removeEventListener(IOErrorEvent.IO_ERROR, handleIOError);
			super.removeEventListener(IOErrorEvent.DISK_ERROR, handleIOError);
			super.removeEventListener(IOErrorEvent.NETWORK_ERROR, handleIOError);
			super.removeEventListener(IOErrorEvent.VERIFY_ERROR, handleIOError);
			super.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
			
			if (_isLoading)
			{
				try
				{
					close();
				}
				catch (error:Error)
				{
					if (_debug) logWarn("destruct: " + error.message);
				}
			}
			if (_eventListenerManager)
			{
				_eventListenerManager.destruct();
				_eventListenerManager = null;
			}
			_isDestructed = true;
		}
	}
}
