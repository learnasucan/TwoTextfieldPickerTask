//
//  ViewController.swift
//  Test1
//
//  Created by Prachit on 15/01/24.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    

    @IBOutlet weak var stateTextfield: UITextField!
    
    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    let state1 = State(name: "MH", cities:[City(name: "Pune"),
                                           City(name: "THane")
                                          ])
                       
    let state2 = State(name: "JH", cities:[City(name: "Ranchi")])
    var states: [State] = [State]()
    var selectedState: State?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        states = [state1,state2]
        
        pickerView.delegate = self
        pickerView.dataSource = self
        stateTextfield.delegate = self
        cityTextField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        cityTextField.inputView = pickerView
    }

    @objc func dismissKeyboard() {
        updateCityPicker()
        view.endEditing(true)
    }
    

}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return selectedState?.cities.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return selectedState?.cities[row].name ?? ""
    }
    
    fileprivate func updateTextField(_ pickerView: UIPickerView) {
        let selectedRow = pickerView.selectedRow(inComponent: 0)
        cityTextField.text =  selectedState?.cities[selectedRow].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        updateTextField(pickerView)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == stateTextfield {
            
            let newText  =  (textField.text as? NSString)?.replacingCharacters(in: range, with: string) ?? ""
            if newText.isEmpty {
                cityTextField.text = ""
            }
        }
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == stateTextfield {
            //Update picker

            
            if let inputStateName = stateTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines){
               let foundState  = findState(inputStateName)
                selectedState = foundState
                //updateCityPicker
                updateCityPicker()
                if !inputStateName.isEmpty {
                    cityTextField.becomeFirstResponder()
                }
            }
            
        }else {
            // Clear the selectedState, update picker, and clear cityTextField
            selectedState = nil
            updateCityPicker()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == stateTextfield {
            updateCityPicker()
            stateTextfield.resignFirstResponder()
//            pickerView.isHidden = true
        } else if textField == cityTextField {
//            updateCityPicker()
            cityTextField.becomeFirstResponder()
        }
        return true
    }
    
    func findState(_ inputText: String)-> State? {
        let state = states.first{ $0.name.lowercased() == inputText.lowercased()}
        return state
    }

    func updateCityPicker(){
        pickerView.reloadAllComponents()
        if let selectedState = selectedState, !selectedState.cities.isEmpty {
            pickerView(pickerView, didSelectRow: 0, inComponent: 0)
        }
    }
}


struct State {
    let name: String
    let cities: [City]
}

struct City  {
    let name: String
}


