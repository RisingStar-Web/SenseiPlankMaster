//
//  TimerViewController.swift
//  SenseiPlankMaster
//
//  Created by Роман Кабиров on 13.09.2018.
//  Copyright © 2018 Logical Mind. All rights reserved.
//

import UIKit
import AVFoundation

class TimerViewController: UIViewController {
    private var prepareTimeSec = 5
    var timeSec: Int = 30
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var labelTimeSec: UILabel!
    @IBOutlet weak var viewProgress: KDCircularProgress!

    private var progressMax: Int = 0
    private var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        labelTimeSec.font = UIFont.monospacedDigitSystemFont(ofSize: 82, weight: .light)
        labelTimeSec.text = String(prepareTimeSec)
        
        hintLabel.text = "Prepare to plank...".localized
        viewProgress.progressColors[0] = UIColor.init(red: 255/255, green: 147/255, blue: 0/255, alpha: 1.0)
        progressMax = prepareTimeSec
        viewProgress.angle = 360.0
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimer), userInfo: nil, repeats: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.isIdleTimerDisabled = true
        if let gestures = self.view.gestureRecognizers as? [UIGestureRecognizer] {
            for gesture in gestures {
                self.view.removeGestureRecognizer(gesture)
            }
        }
    }
    
    @objc func onTimer(sender: Any?) {
        if prepareTimeSec >= 0 {
            prepareTimeSec -= 1
            labelTimeSec.text = String(prepareTimeSec+1)
            if prepareTimeSec < 0 {
                AudioServicesPlayAlertSound(SystemSoundID(1313))
                progressMax = timeSec
                viewProgress.animate(toAngle: 360.0, duration: 0.0, completion: nil)
                hintLabel.text = "Do plank!".localized
                labelTimeSec.text = String(timeSec)
            } else {
                let angle: CGFloat = CGFloat((360 * prepareTimeSec) / progressMax)
                viewProgress.animate(toAngle: Double(angle), duration: 1.0, completion: nil)
            }
        } else {
            labelTimeSec.text = String(timeSec)
            if timeSec <= 0 {
                AudioServicesPlayAlertSound(SystemSoundID(1313))
                timer.invalidate()
                // TODO: - show yes-no successed view
                // dismiss(animated: true, completion: nil)
                let f = storyboard?.instantiateViewController(withIdentifier: "FinalViewController")
                present(f!, animated: true, completion: nil)
                return
            } else {
                let angle: CGFloat = CGFloat((360 * (timeSec-1)) / progressMax)
                viewProgress.animate(toAngle: Double(angle), duration: 1.0, completion: nil)
                timeSec -= 1
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
        UIApplication.shared.isIdleTimerDisabled = false
    }

    @IBAction func backTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
