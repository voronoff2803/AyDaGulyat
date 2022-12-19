//
//  APIService+Auth.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 19.12.2022.
//

import Foundation
import Apollo
import ApolloCombine
import Combine


extension APIService {
    //Auth
    
    func authLoginUser(email: String, password: String) -> AnyPublisher<Bool, BaseError> {
        client.performPublisher(mutation: LoginUserMutation(email: email, password: password))
            .tryMap { res in
                guard let refresh_token = res.data?.loginUser?.refreshToken,
                      let access_token = res.data?.loginUser?.accessToken
                else {
                    throw BaseError(message: res.errors?.first?.localizedDescription ?? "\(#function) method error")
                }
                self.refresh_token = refresh_token
                self.access_token = access_token
                return true
            }
            .mapError({ error in
                self.processError(error: error)
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    
    func authCreateUser(email: String, password: String) -> AnyPublisher<String, BaseError> {
        client.performPublisher(mutation: CreateUserMutation(email: email, password: password))
            .tryMap { res in
                guard res.data?.createUser?.success == true,
                      let userId = res.data?.createUser?.id
                else {
                    throw BaseError(message: res.errors?.first?.localizedDescription ?? "\(#function) method error")
                }
                return userId
            }
            .mapError({ error in
                self.processError(error: error)
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    
    func authResetCodeSend(email: String) -> AnyPublisher<String, BaseError> {
        client.performPublisher(mutation: SendResetMutation(email: email))
            .tryMap { res in
                guard res.data?.sendReset?.success == true,
                      let userId = res.data?.sendReset?.id
                else {
                    throw BaseError(message: res.errors?.first?.localizedDescription ?? "\(#function) method error")
                }
                return userId
            }
            .mapError({ error in
                self.processError(error: error)
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    
    func authResetPassword(newPassword: String) -> AnyPublisher<Bool, BaseError> {
        client.performPublisher(mutation: ResetPasswordMutation(newPassword: newPassword))
            .tryMap { res in
                guard res.data?.resetPassword?.success == true
                else {
                    throw BaseError(message: res.errors?.first?.localizedDescription ?? "\(#function) method error")
                }
                return true
            }
            .mapError({ error in
                self.processError(error: error)
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    
    func authSendCode(email: String) -> AnyPublisher<String, BaseError> {
        client.performPublisher(mutation: SendCodeMutation(email: GraphQLNullable.some(email)))
            .tryMap { res in
                guard res.data?.sendCode?.success == true
                else {
                    throw BaseError(message: res.errors?.first?.localizedDescription ?? "\(#function) method error")
                }
                return res.data?.sendCode?.id ?? ""
            }
            .mapError({ error in
                self.processError(error: error)
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func authValidateCode(code: String, id: String) -> AnyPublisher<Bool, BaseError> {
        client.performPublisher(mutation: ValidateCodeMutation(code: code, validateCodeId: id))
            .tryMap { res in
                guard let refresh_token = res.data?.validateCode?.refreshToken,
                      let access_token = res.data?.validateCode?.accessToken
                else {
                    throw BaseError(message: res.errors?.first?.localizedDescription ?? "\(#function) method error")
                }
                self.refresh_token = refresh_token
                self.access_token = access_token
                return true
            }
            .mapError({ error in
                self.processError(error: error)
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
