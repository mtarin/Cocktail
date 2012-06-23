/*
	This file is part of Cocktail http://www.silexlabs.org/groups/labs/cocktail/
	This project is © 2010-2011 Silex Labs and is released under the GPL License:
	This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License (GPL) as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version. 
	This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
	To read the license please visit http://www.gnu.org/copyleft/gpl.html
*/
package cocktail.core.window;

import cocktail.core.dom.Document;
import cocktail.core.event.Event;
import cocktail.core.event.EventCallback;
import cocktail.core.html.HTMLAnchorElement;
import cocktail.core.html.HTMLConstants;
import cocktail.core.html.HTMLDocument;
import cocktail.port.platform.Platform;
import cocktail.core.style.StyleData;

/**
 * Represents the window through which the Document is
 * viewed
 * 
 * It holds a reference to the class proxying access
 * to platform specific event and methods
 * 
 * TODO 3 : should implement onload callback
 * 
 * @author Yannick DOMINGUEZ
 */
class Window extends EventCallback
{
	/**
	 * return the document viewed through the window
	 */
	public var document(default, null):HTMLDocument;
	
	/**
	 * Height (in pixels) of the browser window viewport including,
	 * if rendered, the horizontal scrollbar.
	 */
	public var innerHeight(get_innerHeight, never):Int;
	
	/**
	 * Width (in pixels) of the browser window viewport including,
	 * if rendered, the vertical scrollbar.
	 */
	public var innerWidth(get_innerWidth, never):Int;
	
	/**
	 * A reference to the class through which platform specific
	 * events and methods are retrieved
	 */
	private var _platform:Platform;
	
	//////////////////////////////////////////////////////////////////////////////////////////
	// CONSTRUCTOR & INIT
	//////////////////////////////////////////////////////////////////////////////////////////
	
	/**
	 * class constructor. Initialise the Document
	 */
	public function new() 
	{
		super();
		init();
	}
	
	/**
	 * Initialise the Document and set platform specific
	 * listener on it
	 */
	private function init():Void
	{
		_platform = new Platform();
		
		var htmlDocument:HTMLDocument = new HTMLDocument();
		
		_platform.onmousedown = htmlDocument.onPlatformMouseEvent;
		_platform.onmouseup = htmlDocument.onPlatformMouseEvent;
		_platform.onmousemove = htmlDocument.onPlatformMouseMoveEvent;
		_platform.onclick = htmlDocument.onPlatformMouseClickEvent;
		_platform.onmousewheel = htmlDocument.onPlatformMouseWheelEvent;
		
		_platform.onkeydown = htmlDocument.onPlatformKeyDownEvent;
		_platform.onkeyup = htmlDocument.onPlatformKeyUpEvent;
		
		_platform.onresize = htmlDocument.onPlatformResizeEvent;
		
		//fullscreen callbacks
		htmlDocument.onEnterFullscreen = onDocumentEnterFullscreen;
		htmlDocument.onExitFullscreen = onDocumentExitFullscreen;
		
		//mouse cursor callback
		htmlDocument.onSetMouseCursor = onDocumentSetMouseCursor;
		
		document = htmlDocument;
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////
	// PUBLIC METHOD
	//////////////////////////////////////////////////////////////////////////////////////////
	
	/**
	 * Creates a new secondary browser window and loads the referenced resource.
	 */
	public function open(url:String, name:String = HTMLConstants.TARGET_BLANK):Void
	{
		_platform.open(url, name);
	}
	
		
	//////////////////////////////////////////////////////////////////////////////////////////
	// FULLSCREEN CALLBACKS
	//////////////////////////////////////////////////////////////////////////////////////////
	
	/**
	 * Called when the document request to enter fullscreen mode.
	 * Start fullscreen mode using platform specific API
	 */
	private function onDocumentEnterFullscreen():Void
	{
		_platform.enterFullscreen();
	}
		
	/**
	 * Called when the document request to exit fullscreen mode.
	 * Exit fullscreen mode using platform specific API
	 */
	private function onDocumentExitFullscreen():Void
	{
		_platform.exitFullscreen();
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////
	// MOUSE CURSOR CALLBACKS
	//////////////////////////////////////////////////////////////////////////////////////////
	
	/**
	 * Change the current mouse cursor if needed
	 */
	private function onDocumentSetMouseCursor(cursor:Cursor):Void
	{
		_platform.setMouseCursor(cursor);
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////
	// SETTERS/GETTERS
	//////////////////////////////////////////////////////////////////////////////////////////
	
	private function get_innerHeight():Int
	{
		return _platform.innerHeight;
	}
	
	private function get_innerWidth():Int
	{
		return _platform.innerWidth;
	}
}