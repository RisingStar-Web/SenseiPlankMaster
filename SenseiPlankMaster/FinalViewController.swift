//
//  FinalViewController.swift
//  SenseiPlankMaster
//
//  Created by Роман Кабиров on 13.09.2018.
//  Copyright © 2018 Logical Mind. All rights reserved.
//

import UIKit

class FinalViewController: UIViewController {
    @IBOutlet weak var buttonNo: UIButton!
    @IBOutlet weak var buttonYes: UIButton!
    var isSucceed: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton(buttonYes)
        setupButton(buttonNo)

    }

    @IBAction func buttonNoTap(_ sender: Any) {
        performSegue(withIdentifier: "unwindToMain", sender: self)
    }
    
    @IBAction func buttonYesTap(_ sender: Any) {
        // TODO: - increment day
        isSucceed = true
        performSegue(withIdentifier: "unwindToMain", sender: self)
    }
    
    func setupButton(_ button: UIButton) {
        button.layer.cornerRadius = 8.0
        button.clipsToBounds = true
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let gestures = self.view.gestureRecognizers as? [UIGestureRecognizer] {
            for gesture in gestures {
                self.view.removeGestureRecognizer(gesture)
            }
        }
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
