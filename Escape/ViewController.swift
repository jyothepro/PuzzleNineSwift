//
//  ViewController.swift
//  Escape
//
//  Created by Jyothidhar Pulakunta on 6/6/14.
//  Copyright (c) 2014 Jyothidhar Pulakunta. All rights reserved.
//

import UIKit

let PuzzleSize:Int = 60;
let StartX:Int = 60;
let StartY:Int = 100;
let Space:Int = 10;


class ViewController: UIViewController {
	var puzzleModel:Model;
	var moves:UILabel;

	init(coder aDecoder: NSCoder!) {
		puzzleModel = Model()
		moves = UILabel()

		super.init(coder: aDecoder)
	}


	init(nibName: String!,nibBundle: NSBundle!) {
		puzzleModel = Model()
		moves = UILabel()
		super.init(nibName: nibName, bundle: nibBundle)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		self.moves = UILabel(frame:CGRectMake(200, 50, 50, 20));
		self.moves.text = "0";

		var numMoves:UILabel = UILabel(frame:CGRectMake(75, 50, 100, 20));
		numMoves.text = "Moves";

		self.view.addSubview(numMoves)
		self.view.addSubview(moves)
		placeViews()


	}

	func placeViews() {
		let postions:Dictionary<Int, CGRect> = self.puzzleModel.positionForTiles(Double(StartX), y: Double(StartY), side: Double(PuzzleSize), space: Double(Space))

		for i in reverse(0...postions.count-2) {
			var view: UIView = UIView(frame: postions[i]!)
			if (i != 8) {
				view.backgroundColor = UIColor(red: 52.0/255.0, green: 170.0/255.0, blue: 220.0/255.0, alpha: 1.0)
				var label:UILabel = UILabel(frame:CGRectMake(25.0, 20.0, 30.0, 30.0))
				label.text = String(i+1)
				label.textColor = UIColor(red: 51.0/255.0, green:51.0/255.0, blue:51.0/255.0, alpha:1.0)
				label.font = UIFont(name: "DamascusBold", size: 17.0)
				view.addSubview(label)

				let tap:UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:"handleGesture:")
				tap.enabled = true
				tap.numberOfTapsRequired = 1
				view.tag = i+1
				view.addGestureRecognizer(tap)
				view.userInteractionEnabled = true
			}
			self.view.addSubview(view);
		}

	}

	func handleGesture(gestureRecognizer:UIGestureRecognizer ) {
		if (gestureRecognizer.view.tag >= 1 && gestureRecognizer.view.tag <= 8) {
			//Check if the view can animate
			let canAnimate:Bool = self.puzzleModel.isValidMove(gestureRecognizer.view.tag-1, space: Double(Space))
			//Animate the view to the new position
			if (canAnimate) {
				UIView.animateWithDuration(1, animations: {
					let temp: CGRect = self.puzzleModel.positionForTile(8)
					let oldValue: CGRect = self.puzzleModel.positionForTile(gestureRecognizer.view.tag - 1)
					self.puzzleModel.setPositionForTile(gestureRecognizer.view.tag - 1, value: temp)
					self.puzzleModel.setPositionForTile(8, value: oldValue)

					gestureRecognizer.view.frame = temp
					//Update number of moves
					self.updateNumMoves()
				})
			}
		}
	}

	func updateNumMoves() {
		let curMoves:String = self.moves.text
		self.moves.text = String(curMoves.toInt()! + 1)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

