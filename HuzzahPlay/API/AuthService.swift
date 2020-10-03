//
//  AuthService.swift
//  HuzzahPlay
//
//  Created by Apurva Deshmukh on 10/3/20.
//

import Firebase

struct AuthService {
    
    static let shared = AuthService()
    
    func logUserIn(withEmail email: String, password: String, completion: AuthDataResultCallback?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
}
