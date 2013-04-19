/*
 * Cocktail, HTML rendering engine
 * http://haxe.org/com/libs/cocktail
 *
 * Copyright (c) Silex Labs
 * Cocktail is available under the MIT license
 * http://www.silexlabs.org/labs/cocktail-licensing/
*/
package cocktail.core.renderer;
import cocktail.core.background.BackgroundManager;
import cocktail.core.dom.Node;
import cocktail.core.html.HTMLElement;

import cocktail.port.NativeElement;
import cocktail.core.layout.LayoutData;
import cocktail.core.css.CSSData;
import cocktail.core.geom.GeomData;

/**
 * 
 * This is a special sub class of block box
 * for the HTMLBodyElement
 * 
 * @author Yannick DOMINGUEZ
 */
class BodyBoxRenderer extends BlockBoxRenderer
{

	public function new(node:HTMLElement) 
	{
		super(node);
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////
	// OVERRIDEN PRIVATE LAYOUT METHODS
	//////////////////////////////////////////////////////////////////////////////////////////
	
	/**
	 * Overiden as the body's element renderer used height is a special
	 * case where the height should be the height of the initial containing block
	 * if it specified as 'auto'
	 */
	override private function layoutSelfIfNeeded(forceLayout:Bool):Void
	{
		if (_needsLayout == false && forceLayout == false)
		{
			return;
		}
		
		super.layoutSelfIfNeeded(forceLayout);
		
		if (coreStyle.isAuto(coreStyle.height) == true && (isPositioned() == false || isRelativePositioned() == true))
		{
			var usedValues:UsedValuesVO = coreStyle.usedValues;
			usedValues.height = containingBlock.getContainerBlockData().height - usedValues.marginTop - usedValues.marginBottom
			- usedValues.paddingTop - usedValues.paddingBottom;
		}
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////
	// OVERRIDEN PRIVATE MARGIN COLLAPSING METHOD
	//////////////////////////////////////////////////////////////////////////////////////////
	
	/**
	 * the body renderer don't collapse with the initial
	 * block box
	 */
	override private function collapseTopMarginWithParentTopMargin():Bool
	{
		return false;
	}
	
	/**
	 * same as above
	 */
	override private function collapseBottomMarginWithParentBottomMargin():Bool
	{
		return false;
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////
	// OVERRIDEN PRIVATE HELPER METHODS
	//////////////////////////////////////////////////////////////////////////////////////////
	
	/**
	 * Overriden as when the body's height is specified as auto,
	 * it is considered not auto for its children at it takes
	 * the viewport's height instead of its content height
	 */
	override public function getContainerBlockData():ContainingBlockVO
	{
		super.getContainerBlockData();
		
		if (coreStyle.isAuto(coreStyle.height) == true && (isPositioned() == false || isRelativePositioned() == true))
		{
			_containerBlockData.isHeightAuto = false;
		}
		
		return _containerBlockData;
	}
	
	/**
	 * The HTMLBodyElement uses the bounds of the viewport
	 * for its background
	 */
	override private function getBackgroundBounds(scrollOffset:PointVO):RectangleVO
	{
		var windowData:ContainingBlockVO = getWindowData();
		
		var width:Float = windowData.width;
		var height:Float = windowData.height;
		bounds.width = width;
		bounds.height = height;
		bounds.x = 0.0;
		bounds.y = 0.0;
		
		return bounds;
	}
	
	
}