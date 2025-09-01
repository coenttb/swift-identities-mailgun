//
//  BusinessDetails.swift
//  swift-identities-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 30/08/2025.
//

import Foundation
import ServerFoundation

public struct BusinessDetails: Sendable {
    public let name: String
    public let supportEmail: EmailAddress
    public let fromEmail: EmailAddress
    
    public init(
        name: String,
        supportEmail: EmailAddress,
        fromEmail: EmailAddress
    ) {
        self.name = name
        self.supportEmail = supportEmail
        self.fromEmail = fromEmail
    }
}