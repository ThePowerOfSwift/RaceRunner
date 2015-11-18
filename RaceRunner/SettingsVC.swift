//
//  SettingsVC.swift
//  RaceRunner
//
//  Created by Joshua Adams on 3/1/15.
//  Copyright (c) 2015 Josh Adams. All rights reserved.
//

import UIKit

class SettingsVC: ChildVC {
    @IBOutlet var unitsToggle: UISwitch!
    @IBOutlet var publishRunToggle: UISwitch!
    @IBOutlet var multiplierSlider: UISlider!
    @IBOutlet var multiplierLabel: UILabel!
    @IBOutlet var viewControllerTitle: UILabel!
    @IBOutlet var showMenuButton: UIButton!
    @IBOutlet var autoStopToggle: UISwitch!
    @IBOutlet var autoStopButton: UIButton!
    @IBOutlet var splitsToggle: UISwitch!
    @IBOutlet var splitsButton: UIButton!
    @IBOutlet var neverButton: UIButton!
    @IBOutlet var noneButton: UIButton!
    @IBAction func showMenu(sender: UIButton) {
        showMenu()
    }
    
    override func viewDidLoad() {
        if SettingsManager.getUnitType() == .Imperial {
            unitsToggle.on = false
        }
        else {
            unitsToggle.on = true
        }
        if SettingsManager.getPublishRun() == true {
            publishRunToggle.on = true
        }
        else {
            publishRunToggle.on = false
        }
        updateSplitsWidgets()
        updateAutoStopWidgets()
        updateMultiplierLabel()
        multiplierSlider.value = Float(SettingsManager.getMultiplier())
        viewControllerTitle.attributedText = UiHelpers.letterPressedText(viewControllerTitle.text!)
        showMenuButton.setImage(UiHelpers.maskedImageNamed("menu", color: UiConstants.lightColor), forState: .Normal)
    }
    
    func updateDistanceWidgets(interval: Double, button: UIButton, toggle: UISwitch, prefix: String) {
        let buttonTitle: String
        if interval == RunVC.never {
            toggle.on = false
            buttonTitle = ""
        }
        else {
            toggle.on = true
            if interval < 1.0 {
                buttonTitle = String(format: "%@ %.2f %@", prefix, interval, Stringifier.getCurrentLongUnitName())
            }
            else if interval == 1.0 {
                buttonTitle = "\(prefix) 1 \(Stringifier.getCurrentLongUnitName())"
            }
            else { // interval > 1.0
                buttonTitle = String(format: "%@ %.2f %@", prefix, interval, Stringifier.getCurrentPluralLongUnitName())
            }
        }
        button.setTitle(buttonTitle, forState: .Normal)
    }
    
    func updateSplitsWidgets() {
        updateDistanceWidgets(SettingsManager.getReportEvery(), button: splitsButton, toggle: splitsToggle, prefix: "Every")
    }

    func updateAutoStopWidgets() {
        updateDistanceWidgets(SettingsManager.getStopAfter(), button: autoStopButton, toggle: autoStopToggle, prefix: "After")
    }
    
    @IBAction func toggleUnitType(sender: UISwitch) {
        if sender.on {
            SettingsManager.setUnitType(.Metric)
        }
        else {
            SettingsManager.setUnitType(.Imperial)
        }
        updateSplitsWidgets()
        updateAutoStopWidgets()
    }

    @IBAction func togglePublishRun(sender: UISwitch) {
        if sender.on {
            SettingsManager.setPublishRun(true)
        }
        else {
            SettingsManager.setPublishRun(false)
        }
    }
    
    @IBAction func toggleAutoStop(sender: UISwitch) {
        if sender.on {
            setAutoStop()
        }
        else {
            SettingsManager.setStopAfter(RunVC.never)
            updateAutoStopWidgets()
        }
    }
    
    @IBAction func toggleSplits(sender: UISwitch) {
        if sender.on {
            setSplits()
        }
        else {
            SettingsManager.setReportEvery(RunVC.never)
        }
        updateSplitsWidgets()
    }
    
    @IBAction func neverAutoStop() {
        if autoStopToggle.on {
            autoStopToggle.on = false
            autoStopButton.setTitle("", forState: .Normal)
            SettingsManager.setStopAfter(RunVC.never)
        }
    }
    
    func setAutoStop() {
        getDistanceInterval("How many \(Stringifier.getCurrentPluralLongUnitName()) would you like to stop the run after?")
        { newValue in
            SettingsManager.setStopAfter(newValue)
            self.updateAutoStopWidgets()
        }
    }
    
    @IBAction func dontReportSplits() {
        if splitsToggle.on {
            splitsToggle.on = false
            splitsButton.setTitle("", forState: .Normal)
            SettingsManager.setReportEvery(RunVC.never)
        }
    }

    func setSplits() {
        getDistanceInterval("How far in \(Stringifier.getCurrentPluralLongUnitName()) would you like to run between audible reports of your progress?")
        { newValue in
            SettingsManager.setReportEvery(newValue)
            self.updateSplitsWidgets()
        }
    }
    
    func getDistanceInterval(prompt: String, closure: (Double) -> Void) {
        let alertController = UIAlertController(title: "👟", message: prompt + " To begin inputting, tap \"123\" on the bottom-left corner of your virtual keyboard.", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.view.tintColor = UiConstants.darkColor
        let setAction = UIAlertAction(title: "Set", style: UIAlertActionStyle.Default, handler: { (action) in
            let textFields = alertController.textFields!
            closure(Double(textFields[0].text!)!)
        })
        alertController.addAction(setAction)
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Distance"
            textField.keyboardType = UIKeyboardType.Default
        }
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func multiplierChanged(sender: UISlider) {
        SettingsManager.setMultiplier(round(Double(sender.value)))
        updateMultiplierLabel()
    }
    
    func updateMultiplierLabel() {
        multiplierLabel.text = String(format: "%.0f%%", SettingsManager.getMultiplier() * 100.0)
    }
}