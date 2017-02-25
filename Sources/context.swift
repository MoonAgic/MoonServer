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
    case wrongPasswdOrAccountNotFount = 1
    case accountNotFount = 2
}
		
