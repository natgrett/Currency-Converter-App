//
//  ViewController.swift
//  iOS4-Pidhorodetska
//
//  Created by Nataliia Pighorodetska on 26.11.19.
//  Copyright © 2019 Nataliia Pighorodetska. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    var rateDollar = 1.10635
    var ratePfund =  0.85695
    var euro = 0.0
    var dollars = 0.0
    var pfund = 0.0
    var finanzenEuroUSDollars: String = ""
    var finanzenEuroBrPfund: String = ""
    var textInHistory = "\n \n \n \n \n"
    var oldHistory = ""
    @IBOutlet weak var exchangeRateDollar: UITextField!
    @IBOutlet weak var exchangeRatePfund: UITextField!
    @IBOutlet weak var euroInEuro: UITextField!
    @IBOutlet weak var euroInDollars: UITextField!
    @IBOutlet weak var euroInPfund: UITextField!
    @IBOutlet weak var history: UILabel!
    
    //-------- UTILITY --------
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func formatForDouble (_ number: Double) -> String {
        return String (format: "%.2lf", number)
    }
    
    //-------- WORKING WITH HISTORY ---------
    @IBAction func deleteHistory(_ sender: Any) {
        oldHistory = ""
        textInHistory = "\n \n \n \n \n"
        history.text = textInHistory
    }
    
    func historyText () {
        oldHistory = textInHistory
        textInHistory = "\(euroInEuro.text ?? "0.00")€ = \(euroInDollars.text ?? "0.00")$ = \(euroInPfund.text ?? "0.00")£\n\(oldHistory)"
        history.numberOfLines = 5
        history.text = textInHistory
    }
    
    
    //-------- Two SMALL TextFields for Change Rates --------
    @IBAction func changeRateDollars(_ sender: Any) {
        rateDollar = Double (exchangeRateDollar.text ?? "") ?? 0.0
        euroChanged ()
        dollarsChanged ()
        pfundChanged ()
        historyText()
    }
    
    @IBAction func changeRatePfund(_ sender: Any) {
        //        LONG VERSION
        /* if let line = exchangeRateDollar.text {
         if let convertedNumber = Double(line){
         ratePfund = convertedNumber
         }
         }
         */
        //        SHORT VERSION
        ratePfund = Double (exchangeRatePfund.text ?? "") ?? 0.0
        euroChanged ()
        dollarsChanged ()
        pfundChanged ()
        historyText()
    }
    //-------- Three BIG TextFields for resalts --------
    func euroChanged () {
        euro = Double(euroInEuro.text ?? "") ?? 0.0
        euroInEuro.text = formatForDouble (euro)
        euroInDollars.text = formatForDouble (euro * rateDollar)
        euroInPfund.text = formatForDouble(euro * ratePfund)
        
    }
    @IBAction func euroInEuroChanged(_ sender: Any) {
        euroChanged ()
        historyText()
    }
    
    func dollarsChanged () {
        dollars = Double(euroInDollars.text ?? "") ?? 0.0
        euroInDollars.text = formatForDouble(dollars)
        euroInPfund.text = formatForDouble (dollars/rateDollar * ratePfund)
        euroInEuro.text = formatForDouble (dollars/rateDollar)
    }
    @IBAction func euroInDollarsChanged(_ sender: Any) {
        dollarsChanged ()
        historyText()
    }
    
    func pfundChanged () {
        pfund = Double(euroInPfund.text ?? "") ?? 0.0
        euroInPfund.text = formatForDouble (pfund)
        euroInEuro.text = formatForDouble (pfund/ratePfund)
        euroInDollars.text = formatForDouble (pfund/ratePfund * rateDollar)
        
    }
    @IBAction func euroInPfundChanged(_ sender: Any) {
        pfundChanged ()
        historyText()
    }
    
    //-------- Read Dates from WWW --------
    //    make string from html-Date from site with URL url
    func stringFrom (url: String) -> String {
        if let optimalUrl = URL(string: url) {
            do {
                let contents = try String(contentsOf: optimalUrl, encoding: .utf8)
                return contents
            } catch {
                // contents could not be loaded
            }
        }
        return ""
    }
    
    //    find a double rate in String. withOldRate is alternativ for Rate
    func ratesFromInternetWith (html: String, withOldRate: Double) -> Double {
        let range: Range<String.Index> = html.range(of: "<input value=\"")!
        let startIndex = range.upperBound
        let partOfHtml = html[startIndex..<html.endIndex]
        let secondRange: Range<String.Index> = partOfHtml.range(of: "\"")!
        let newChatgedRate = html [startIndex..<secondRange.lowerBound].replacingOccurrences(of: ",", with: ".")
        return  Double(newChatgedRate) ?? withOldRate
    }
    @IBAction func readOnlineRates(_ sender: Any) {
        //here are addresses where the exchange rate is taken from //NOW WITHOUT RATES FROM INTERNET
        /* finanzenEuroUSDollars = stringFrom(url: "here site for Dollars")
         finanzenEuroBrPfund = stringFrom(url: "here site for Pfunds ")
         */
        
        //here are rate Dollars and rate Pfund from Internet
        //NOW WITHOUT RATES FROM INTERNET
        /*rateDollar = ratesFromInternetWith(html: finanzenEuroUSDollars, withOldRate: rateDollar)
        ratePfund = ratesFromInternetWith(html: finanzenEuroBrPfund, withOldRate: ratePfund)*/
        
//      crazy courses (Because WITHOUT RATES FROM INTERNET)
        rateDollar = 100.0
        ratePfund = 100.0
        exchangeRateDollar.text = "\(rateDollar)"
        exchangeRatePfund.text =  "\(ratePfund)"
        euroChanged()
        dollarsChanged()
        pfundChanged()
        historyText()
    }
    // -------- Delete TextField --------
    @IBAction func deleteOldDates(_ sender: Any) {
        euroInPfund.text = formatForDouble (0.0)
        euroInEuro.text = formatForDouble (0.0)
        euroInDollars.text = formatForDouble (0.0)
    }
    
    // -------- Delete TextField in the moment of entry new data --------
    func cleanTextIn (field: UITextField! ) {
        field.text = ""
    }
    @IBAction func newEuroValues(_ sender: Any) {
        cleanTextIn (field: euroInEuro)
    }
    @IBAction func newDollarsValues(_ sender: Any) {
        cleanTextIn (field: euroInDollars)
    }
    @IBAction func newPfundValues(_ sender: Any) {
        cleanTextIn (field: euroInPfund)
    }
    @IBAction func newRateForDollars(_ sender: Any) {
        cleanTextIn (field: exchangeRateDollar)
    }
    
    @IBAction func newRateForPfund(_ sender: Any) {
        cleanTextIn (field: exchangeRatePfund)
    }
    
    
    
    // --------  Do any additional setup after loading the view. --------
    override func viewDidLoad() {
        super.viewDidLoad()
        history.text = ""
        exchangeRateDollar.text = "\(rateDollar)"
        exchangeRatePfund.text = "\(ratePfund)"
        euroInEuro.text = formatForDouble (euro)
        euroInDollars.text = formatForDouble (dollars)
        euroInPfund.text = formatForDouble (pfund)
    }
    
    
}

