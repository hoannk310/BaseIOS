//
//  BaseViewModel.swift
//  BaseIOS
//
//  Created by Hoàn Nguyễn on 3/6/25.
//

import RxSwift

protocol BaseViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
