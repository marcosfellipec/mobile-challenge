//
//  ViewController.swift
//  mobile-challenge
//
//  Created by Marcos Fellipe Costa Silva on 24/04/21.
//

import UIKit

class MainViewController: UIViewController {
    
    private var currencyList: [Quote] = [] {
        didSet {
            DispatchQueue.main.async {
                self.totalQuotesLabel.text = "Cotações disponíveis: \(self.currencyList.count)"
            }
        }
    }
    
    private var currencyLeft = CurrencyDescription() {
        didSet {
            currencyOneButtonOutlet.setTitle(currencyLeft.key, for: .normal)
        }
    }
    private var currencyRight = CurrencyDescription(){
        didSet {
            currencyTwoButtonOutlet.setTitle(currencyRight.key, for: .normal)
        }
    }
    private var selectedCurrencyEnum = CurrencySelectedEnum.left {
        didSet {
            if currencyList.isEmpty {
                AlertMessage.showOk(title: "Atenção", message: "Antes de selecionar uma moeda, atualize a cotação.")
                return
            }
            performSegue(withIdentifier: "listCurrencySegue", sender:nil)
        }
    }
    
    @IBOutlet weak var currencyOneButtonOutlet: UIButton!
    @IBOutlet weak var currencyTwoButtonOutlet: UIButton!
    @IBOutlet weak var currencyTextField: MoneyFormatTextField!
    @IBOutlet weak var calcResulLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var totalQuotesLabel: UILabel!
    
    @IBAction func currencyLeftAction(_ sender: Any) {
        selectedCurrencyEnum = .left
    }
    
    @IBAction func currencyRightAction(_ sender: Any) {
        selectedCurrencyEnum = .right
    }
    
    @IBAction func calcAction(_ sender: Any) {
        guard let currencyOneValueBase = currencyList.filter({$0.key == "USD"+currencyLeft.key}).first, let currencyTwoValueBase = currencyList.filter({$0.key == "USD"+currencyRight.key}).first else {
            AlertMessage.showOk(title: "Atenção", message: "É necessário selecionar 2 moedas para realizar a conversão.")
            return
        }
        
        let currencyValue = Double(currencyTextField.cleanText ) ?? 0.0
        var result = 0.0
        if currencyValue > 0 {
            result = (currencyValue / currencyOneValueBase.value) * currencyTwoValueBase.value
        }
        
        calcResulLabel.text = String(format: "%.2f", result).currencyFormat
        
    }
    
    @IBAction func swapCurrenciesAction(_ sender: Any) {
        
        if currencyLeft.key.isEmpty || currencyRight.key.isEmpty {
            AlertMessage.showOk(title: "Atenção", message: "É necessário selecionar 2 moedas primeiro.")
            return
        }
        
        let currecyAux = currencyRight
        currencyRight = currencyLeft
        currencyLeft = currecyAux
        calcAction("")
    }
    
    @IBAction func refreshQuotes(_ sender: Any) {
        getQuotes()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.hideKeyboard()
        getQuotes()
    }
    
    private func getQuotes() {
        refreshButton.rotateAnimation()
        APICurrency.getLive { (result) in
            self.refreshButton.removeAllAnimations()
            
            switch (result) {
            case .success(let currencyModel):
                self.currencyList = currencyModel.quotes
            case .failure(let error):
                print(error)
                AlertMessage.showOk(title: "Atenção", message: "Parece que algo deu errado. Tente novamente.")
            case .connectivityError:break
                
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "listCurrencySegue" {
            let vc = segue.destination as! ListViewController
            vc.delegate = self
            vc.currencySelectedEnum = selectedCurrencyEnum
            
        }
    }

}

extension MainViewController: ChooseCurrencyDelegate {
    func didSelected(currencyDescription: CurrencyDescription, type: CurrencySelectedEnum) {
        switch type {
        case .left:
            currencyLeft = currencyDescription
        case .right:
            currencyRight = currencyDescription
        }
    }
}

