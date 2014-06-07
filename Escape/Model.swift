//
//  Model.swift
//  Escape
//
//  Created by Jyothidhar Pulakunta on 6/6/14.
//  Copyright (c) 2014 Jyothidhar Pulakunta. All rights reserved.
//

import Foundation
import UIKit

let NumTiles = 9;

class Model {
	var tilePositions = Dictionary<Int, CGRect>()
	init() {

	}

	func generatePositions(x: Double, y: Double, side: Double, space: Double) -> Array<CGRect> {
		var generatedPos:Array<CGRect> = Array<CGRect>()
		var X = x
		var Y = y
		for i in 0...NumTiles-1 {
			let rect:CGRect = CGRectMake(CGFloat(X), CGFloat(Y), CGFloat(side), CGFloat(side))
			generatedPos.insert(rect, atIndex: i)
//			generatedPos[i] = rect
			if ((i+1) % 3 == 0) {
				Y += side + space
				X = x
			} else {
				X += side + space
			}
		}
		return generatedPos
	}

	func positionForTiles(x: Double, y: Double, side: Double, space: Double) -> Dictionary<Int, CGRect> {
		var positions:Array<CGRect> = self.generatePositions(x, y: y, side: side, space: space);
		for i in 0..NumTiles {
			let selIndex:Int = Int(arc4random_uniform(UInt32(positions.count)));
			let selPos:CGRect = positions[i]
			self.tilePositions[i] = selPos;
		}
		return self.tilePositions
	}

	func positionForTile(tileNumber: Int) -> CGRect {
		return self.tilePositions[tileNumber]!
	}

	func setPositionForTile(tileNumber: Int, value:CGRect) {
		self.tilePositions[tileNumber] = value;
	}

	func isValidMove(tileNumber: Int, space: Double) -> Bool {
		let rect:CGRect = self.tilePositions[tileNumber]!
		let ninePosition:CGRect = self.tilePositions[8]!
		let paddedRectLeft:CGRect = CGRectMake(ninePosition.origin.x,
										ninePosition.origin.y,
										ninePosition.size.width + CGFloat(space) + CGFloat(1.0),
										ninePosition.size.height);
		let paddedRectTop:CGRect = CGRectMake(ninePosition.origin.x,
										ninePosition.origin.y,
										ninePosition.size.width,
										ninePosition.size.height + CGFloat(space) + CGFloat(1.0));
		let paddedRectRight:CGRect = CGRectMake(ninePosition.origin.x - CGFloat(space) - CGFloat(1.0),
										ninePosition.origin.y,
										ninePosition.size.width + CGFloat(space) + CGFloat(1.0),
										ninePosition.size.height);
		let paddedRectBottom:CGRect = CGRectMake(ninePosition.origin.x,
										ninePosition.origin.y - CGFloat(space) - CGFloat(1.0),
										ninePosition.size.width,
										ninePosition.size.height + CGFloat(space) + CGFloat(1.0));

		if (CGRectIntersectsRect(rect, paddedRectLeft) ||
			CGRectIntersectsRect(rect, paddedRectRight) ||
			CGRectIntersectsRect(rect, paddedRectBottom) ||
			CGRectIntersectsRect(rect, paddedRectTop)) {
			return true;
		}

		return false
	}

}
