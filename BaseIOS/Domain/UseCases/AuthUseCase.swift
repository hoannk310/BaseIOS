//
//  NewsUseCase.swift
//  BaseIOS
//
//  Created by Nguyen Khai Hoan on 12/3/25.
//

import RxSwift

protocol AuthUseCase {
    func login(param: LoginRequestEntity) -> Single<UserEntity>
    func register(param: RegisterRequestEntity) -> Single<UserEntity>
    func getListImage() -> Single<[String]>
}

class AuthUseCaseImpl: AuthUseCase {
    @Injected
    private var authRepository: AuthRepository
    
    func login(param: LoginRequestEntity) -> Single<UserEntity> {
        authRepository.login(param: param)
    }
    
    func register(param: RegisterRequestEntity) -> Single<UserEntity> {
        authRepository.register(param: param)
    }
    
    func getListImage() -> Single<[String]> {
        return Single.just([
            "https://images.unsplash.com/photo-1603415526960-f7e0328c63b1",
            "https://images.unsplash.com/photo-1547721064-da6cfb341d50",
            "https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d",
            "https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e",
            "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde",
            "https://images.unsplash.com/photo-1494790108377-be9c29b29330",
            "https://images.unsplash.com/photo-1524504388940-b1c1722653e1",
            "https://images.unsplash.com/photo-1527980965255-d3b416303d12",
            "https://upload.wikimedia.org/wikipedia/commons/3/3f/Fronalpstock_big.jpg",
            "https://upload.wikimedia.org/wikipedia/commons/e/e8/Elephants_Dream_s5_both.jpg",
            "https://upload.wikimedia.org/wikipedia/commons/7/70/Example.png",
            "https://upload.wikimedia.org/wikipedia/commons/1/17/Google-flutter-logo.png",
            "https://upload.wikimedia.org/wikipedia/commons/5/5f/Alberta_Canada_Landscape.jpg",
            "https://example.com/this-image-does-not-exist.jpg",
            "https://nonexistent.domain.com/image.jpg",
            "https://thisurldoesnot.exist/image.png",
            "https://broken.url/image.jpg",
            "https://images.unsplash.com/photo-does-not-exist"
        ])
    }
}
