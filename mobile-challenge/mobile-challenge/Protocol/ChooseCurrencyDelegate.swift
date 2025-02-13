//
//  ChooseCurrencyDelegate.swift
//  mobile-challenge
//
//  Created by Marcos Fellipe Costa Silva on 24/04/21.
//

import Foundation

enum CurrencySelectedEnum {
    case left
    case right
}

protocol ChooseCurrencyDelegate {
    func didSelected(currencyDescription: CurrencyDescription, type: CurrencySelectedEnum)
}
