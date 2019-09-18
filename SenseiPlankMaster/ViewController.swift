//
//  ViewController.swift
//  SenseiPlankMaster
//
//  Created by Роман Кабиров on 12.09.2018.
//  Copyright © 2018 Logical Mind. All rights reserved.
//

import UIKit
import StoreKit

class ViewController: UIViewController {
    @IBOutlet weak var pyramidView: PyramidView!
    @IBOutlet weak var labelCurrentDay: UILabel!
    @IBOutlet weak var imageViewCup: UIImageView!
    @IBOutlet weak var labelLastWorkout: UILabel!
    
    var currentDay = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentDay = UserDefaults.standard.integer(forKey: "current-day")
        
        if InAppPurchse.isFullVersionPurchased == false {
            fetchAvailableProducts()
        }
        
        let runCnt = UserDefaults.standard.integer(forKey: "run-count") + 1
        if runCnt % 20 == 0 {
            SKStoreReviewController.requestReview()
        }
        UserDefaults.standard.set(runCnt, forKey: "run-count")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pyramidView.setupView()
        pyramidView.paintNinja(day: currentDay)
        setCurrentDay()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if currentDay == 30 {
            DispatchQueue.main.async {
                // self.imageViewCup.layer.removeAllAnimations()
                // self.imageViewCup.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
                UIView.animate(withDuration: 1.4, delay: 0.0, options: [.autoreverse, .repeat], animations: {
                    self.imageViewCup.transform = CGAffineTransform.identity.scaledBy(x: 1.4, y: 1.4)
                }, completion: nil)
            }
        }

    }
}

extension ViewController {
    @IBAction func buttonStartTap(_ sender: Any) {
        if (!InAppPurchse.isFullVersionPurchased) && (currentDay > 3) {
            if InAppPurchse.productPriceStr == "" {
                let a = UIAlertController(title: "Warning".localized, message: "Check your internet connection and try again".localized, preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                a.addAction(ok)
                present(a, animated: true, completion: nil)
                return
            }
            
            purchaseFullVersion()
            return
        }
        
        if currentDay >= 30 {
            let a = UIAlertController(title: nil, message: "Do you want to restart?".localized, preferredStyle: .alert)
            let yes = UIAlertAction(title: "Yes".localized, style: .destructive, handler: ({_ in
                self.restartChallenge()
            }))
            let no = UIAlertAction(title: "Cancel".localized, style: .default, handler: nil)
            a.addAction(yes)
            a.addAction(no)
            present(a, animated: true, completion: nil)
            return
        }
        
        if let d = UserDefaults.standard.value(forKey: "last-workout") as? Date {
            let day = Calendar.current.compare(d, to: Date(), toGranularity: .day)
            if day == ComparisonResult.orderedSame {
                let a = UIAlertController(title: nil, message: "You have already trained today! Come back tomorrow 💪🏻".localized, preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                let start = UIAlertAction(title: "Workout anyway".localized, style: .destructive, handler: ({_ in
                    let t = self.storyboard?.instantiateViewController(withIdentifier: "TimerViewController") as! TimerViewController
                    t.timeSec = WorkoutData.days[self.currentDay]
                    self.present(t, animated: true, completion: nil)
                }))
                
                a.addAction(ok)
                a.addAction(start)
                present(a, animated: true, completion: nil)
                return
            }
        }

        let t = storyboard?.instantiateViewController(withIdentifier: "TimerViewController") as! TimerViewController
        t.timeSec = WorkoutData.days[currentDay]
        present(t, animated: true, completion: nil)
    }
    
    @IBAction func unwindToMain(_ segue: UIStoryboardSegue) {
        if let f = segue.source as? FinalViewController {
            if f.isSucceed {
                incCurrentDay()
            }
            
            UserDefaults.standard.set(Date(), forKey: "last-workout")
        }
    }
}

extension ViewController {
    func incCurrentDay() {
        currentDay += 1
        UserDefaults.standard.set(currentDay, forKey: "current-day")
        pyramidView.paintNinja(day: currentDay)
        setCurrentDay()
    }
    
    func setCurrentDay() {
        imageViewCup.isHidden = true
        labelLastWorkout.isHidden = false
        labelLastWorkout.text = ""
        
        if let d = UserDefaults.standard.value(forKey: "last-workout") as? Date {
            let f = DateFormatter()
            f.timeStyle = .none
            f.dateStyle = .medium
            labelLastWorkout.text = "Last workout: ".localized + f.string(from: d)
        }
        
        if currentDay == 30 {
            labelCurrentDay.text = "Congrats! You are Plank Master!".localized
            imageViewCup.isHidden = false
            labelLastWorkout.isHidden = true

            /*
            DispatchQueue.main.async {
                // self.imageViewCup.layer.removeAllAnimations()
                // self.imageViewCup.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
                UIView.animate(withDuration: 1.4, delay: 0.0, options: [.autoreverse, .repeat], animations: {
                    self.imageViewCup.transform = CGAffineTransform.identity.scaledBy(x: 1.4, y: 1.4)
                }, completion: nil)
            }
            */
            
            return
        }
        let timeSec = WorkoutData.days[currentDay]
        labelCurrentDay.text = "Current day:".localized + " \(currentDay + 1) (\(timeSec) " + "sec".localized + ")"

        imageViewCup.layer.removeAllAnimations()
        self.imageViewCup.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
    }
    func restartChallenge() {
        currentDay = 0
        UserDefaults.standard.set(nil, forKey: "last-workout")
        pyramidView.paintNinja(day: currentDay)
        setCurrentDay()
    }
}
