//
//  ProfileViewModel.swift
//  DaItSSo
//
//  Created by 김상규 on 7/9/24.
//

import Foundation

class ProfileViewModel {
    var inputNickname: Observable<String?> = Observable(nil)
    var outputNickname: Observable<String?> = Observable(nil)
    var outputValidText: Observable<String?> = Observable(nil)
    var outputButtonEnabled: Observable<Bool?> = Observable(true)
    
    var outputProfileImg: Observable<String?> = Observable(nil)
    
    init() {
        inputNickname.bind { _ in
            self.validNickname()
        }
    }
    
    private func validNickname() {
        guard let result = inputNickname.value, !result.trimmingCharacters(in: .whitespaces).isEmpty else {
            
            outputButtonEnabled.value = false
            return
        }
        
        guard result.count >= 2 && result.count <= 9 else {
            
            outputValidText.value = ErrorType.CheckNickname.outRange.checkNicknameLabelText
            outputButtonEnabled.value = false
            return
        }
        
        guard result.rangeOfCharacter(from: .decimalDigits) == nil else {
            
            outputValidText.value = ErrorType.CheckNickname.noNumber.checkNicknameLabelText
            outputButtonEnabled.value = false
            return
        }
        
        for str in String.specialStringArray {
            guard !result.contains(str) else {
                
                outputValidText.value = ErrorType.CheckNickname.specialString(str).checkNicknameLabelText
                outputButtonEnabled.value = false
                return
            }
        }
        
        outputButtonEnabled.value = true
        outputNickname.value = result
        outputValidText.value = ErrorType.CheckNickname.ok.checkNicknameLabelText
    }
}
