//
//  Config.swift
//  BUXDemo
//
//  Created by Ilija Puaca on 19/10/17.
//  Copyright © 2017 BUX BV. All rights reserved.
//

import Foundation

/// General purpose config class.
/// Should obviously be much more elaborate - ie. support config overrides with git ignored files etc.
/// It could also read most of these out of .plist file.
class Config {

    // MARK: - Properties

    /// Default config instance.
    static let `default` = Config()

    /// Base URL for the BUX API.
    let buxApiUrl = "https://api.beta.getbux.com/core/16"

    /// Authorization token for API GET requests.
    let buxApiToken = "eyJhbGciOiJIUzI1NiJ9.eyJyZWZyZXNoYWJsZSI6ZmFsc2UsInN1YiI6ImJiMGNkYTJiLWExMGUtNGVkMy1hZDVhLTBmODJiNGMxNTJjNCIsImF1ZCI6ImJldGEuZ2V0YnV4LmNvbSIsInNjcCI6WyJhcHA6bG9naW4iLCJydGY6bG9naW4iXSwiZXhwIjoxODIwODQ5Mjc5LCJpYXQiOjE1MDU0ODkyNzksImp0aSI6ImI3MzlmYjgwLTM1NzUtNGIwMS04NzUxLTMzZDFhNGRjOGY5MiIsImNpZCI6Ijg0NzM2MjI5MzkifQ.M5oANIi2nBtSfIfhyUMqJnex-JYg6Sm92KPYaUL9GKg"

    /// BUX web socket subscription URL.
    let buxWebSocketUrl = "https://rtf.beta.getbux.com/subscriptions/me"

    /// Authorization token for WebSocket requests.
    let buxWebSocketToken = "eyJhbGciOiJIUzI1NiJ9.eyJyZWZyZXNoYWJsZSI6ZmFsc2UsInN1YiI6ImJiMGNkYTJiLWExMGUtNGVkMy1hZDVhLTBmODJiNGMxNTJjNCIsImF1ZCI6ImJldGEuZ2V0YnV4LmNvbSIsInNjcCI6WyJhcHA6bG9naW4iLCJydGY6bG9naW4iXSwiZXhwIjoxODIwODQ5Mjc5LCJpYXQiOjE1MDU0ODkyNzksImp0aSI6ImI3MzlmYjgwLTM1NzUtNGIwMS04NzUxLTMzZDFhNGRjOGY5MiIsImNpZCI6Ijg0NzM2MjI5MzkifQ.M5oANIi2nBtSfIfhyUMqJnex-JYg6Sm92KPYaUL9GKg"

}
