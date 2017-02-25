//
//  context.swift
//  MoonServer
//
//  Created by Moon on 25/02/2017.
//
//


var tokenCache:[String:String] = [:]

enum errorCode: Int {
    case sucsses = 0
    case accountWasRegisted = 1
    case wrongPasswdOrAccountNotFount = 2
    case accountNotFount = 3
}
		
