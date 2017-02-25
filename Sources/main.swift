//
//  main.swift
//  PerfectTemplate
//
//  Created by Kyle Jessup on 2015-11-05.
//  Copyright (C) 2015 PerfectlySoft, Inc.
//
//===----------------------------------------------------------------------===//
//
// This source file is part of the Perfect.org open source project
//
// Copyright (c) 2015 - 2016 PerfectlySoft Inc. and the Perfect project authors
// Licensed under Apache License v2.0
//
// See http://perfect.org/licensing.html for license information
//
//===----------------------------------------------------------------------===//
//

import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import PostgreSQL


// Create HTTP server.
let server = HTTPServer()


// Register your own routes and handlers
var routes = Routes()
routes.add(method: .get, uri: "/", handler: {
        request, response in
        response.setHeader(.contentType, value: "text/html")
        response.appendBody(string: "<html><title>it works!</title><body>it works!</body></html>")
        response.completed()
    }
)
routes.add(method: .post, uri: "/regist", handler: {
    request, response in
    let account:String = request.param(name: "account")!
    let passwd:String = request.param(name: "passwd")!
    if account != "" && passwd != "" {
        let p = PGConnection()
        let status = p.connectdb("postgresql://moon:backstreet@localhost:5432/moondb")
        
        let res = p.exec(statement: "SELECT * FROM _user_table WHERE name = '\(account)'")
        if let registed = res.getFieldString(tupleIndex: 0, fieldIndex: 0) {
            // this account was registed
            print("this account was registed")
            response.setHeader(.contentType, value: "application/json")
            let scoreArray: [String:Any] = ["code": errorCode.accountWasRegisted]
            var encoded = ""
            do {
                encoded = try scoreArray.jsonEncodedString()
            } catch {
                
            }
            response.appendBody(string: encoded)
            response.completed()
        } else {
            // go to regist
            print("go to regist")
            
            let result = p.exec(statement: "INSERT INTO _user_table(name, passwd, signup_date) VALUES('\(account)', '\(passwd)', '2017-02-11');")
            print("\(result.status())")
            if result.status() == .commandOK {
                response.setHeader(.contentType, value: "application/json")
                let scoreArray: [String:Any] = ["code": 200]
                var encoded = ""
                do {
                    encoded = try scoreArray.jsonEncodedString()
                } catch {
                    
                }
                
                response.appendBody(string: encoded)
                response.completed()
            }
        }
        
        defer {
            p.finish()
        }
    }
})
routes.add(method: .post, uri: "/login", handler: {
    request, response in
    let account = request.param(name: "account")
    let passwd = request.param(name: "passwd")
    let p = PGConnection()
    let status = p.connectdb("postgresql://moon:backstreet@localhost:5432/moondb")
    
    let res = p.exec(statement: "SELECT passwd FROM _user_table WHERE name = '\(account!)'")
    if let accountP = res.getFieldString(tupleIndex: 0, fieldIndex: 0) {
        
        let accountPasswd = accountP.stringByReplacing(string: " ", withString: "")
        
        if passwd! == accountPasswd {
            var token = UUID().string
            tokenCache[account!] = token;
            // login sucsses
            response.setHeader(.contentType, value: "application/json")
            let scoreArray: [String:Any] = ["code": 200, "token": token]
            var encoded = ""
            do {
                encoded = try scoreArray.jsonEncodedString()
            } catch {
                
            }
            response.appendBody(string: encoded)
            response.completed()
            return
        } else {
            print("wrong passwd")
        }
        
    }
    // login faild
    let scoreArray: [String:Any] = ["code": 404]
    var encoded = ""
    do {
        encoded = try scoreArray.jsonEncodedString()
    } catch {
        
    }
    response.appendBody(string: encoded)
    response.completed()
})

// Add the routes to the server.
server.addRoutes(routes)

server.serverAddress = "127.0.0.1"
// Set a listen port of 8181
server.serverPort = 8181

// Set a document root.
// This is optional. If you do not want to serve static content then do not set this.
// Setting the document root will automatically add a static file handler for the route /**
server.documentRoot = "./webroot"

// Gather command line options and further configure the server.
// Run the server with --help to see the list of supported arguments.
// Command line arguments will supplant any of the values set above.
configureServer(server)

do {
    // Launch the HTTP server.
    try server.start()
} catch PerfectError.networkError(let err, let msg) {
    print("Network error thrown: \(err) \(msg)")
}
