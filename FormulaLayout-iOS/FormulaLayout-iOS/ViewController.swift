//
//  ViewController.swift
//  FormulaLayout-iOS
//
//  Created by 第五东林 on 2026/06/08.
//

import UIKit

import FormulaLayout

class ViewController: UIViewController {

    let view1 = UIView()
    let view2 = UIView()
    let view3 = UIView()
    let view4 = UIView()
    let label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        view1.backgroundColor = .red
        view2.backgroundColor = .blue
        view3.backgroundColor = .green
        view4.backgroundColor = .magenta
        label.backgroundColor = .red

        [label,view1, view2, view3, view4].forEach(view.addSubview)

        setupConstraints()
    }

    private func setupConstraints() {
        view1.makeFormulas {
            [.centerX, .centerY] == view
            [.height("kkkkkk") => .width] == view1 * 2
//            [.height] == 100
            [.width("llll")] == 100
        }

        //view2.ch(priority: LayoutPriority(1000), axis:.vertical)
        view2.makeFormulas {
            [.top] == view1 + 20
            [.leading, .trailing] == view1 + 30
            [.height] <= view1 * 2.5
            //[.bottom(p:.defaultHigh,c:0, i:"")] == view - 15
        }
        
        label.makeFormulas{
            [.top => .bottom] == view2
            [.leading] == view4
            [.trailing] == view1
            [.height] >= 20
        }
        
        view3.makeFormulas {
            [.bottom("xxxxxx") => .top] == view1
            //[.bottom == .top] == view1 - 5
            [.leading, .trailing, .top] == view.safeAreaLayoutGuide
        }

        view4.makeFormulas {
            //[.leading(20), .trailing(-20), .bottom(-20), .top(20)] == view3
            [.leading, .trailing, .bottom, .top](20) == view3
        }
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view3.updateFormula(identifier:"xxxxxx"){
            [.constant] == -50
            //[.multiplier] == 1.5
        }
        self.view1.updateFormula(identifier:"llll"){
            [.constant] == 200
        }
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if let v = self.view3.findConstraint(identifier:"xxxxxx"){
                v.constant = 0
                //v.update(multiplier:0.5)
                //v.update(multiplier:0.5,constant: 15)
                UIView.animate(withDuration: 0.25) {
                    self.view.layoutIfNeeded()
                }
            }
            if let v = self.view1.findConstraint(identifier:"llll"){
                v.constant = 100
                UIView.animate(withDuration: 0.25) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
}


