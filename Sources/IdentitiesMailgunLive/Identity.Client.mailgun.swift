//
//  Identity.Client.mailgun.swift
//  swift-identities-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 30/08/2025.
//

import Foundation
import Dependencies
import IdentitiesTypes
import Identity_Backend
import IdentitiesMailgun
import Mailgun_Messages_Types
import ServerFoundation

extension Identity.Client {
    /// Creates a live Identity Backend Client that uses Mailgun for sending emails.
    ///
    /// This implementation uses the Mailgun dependency to send all identity-related emails.
    /// It automatically integrates with the application's Mailgun configuration via dependencies.
    ///
    /// - Parameters:
    ///   - business: Business details for email branding and configuration
    ///   - router: Router for generating URLs in emails
    ///   - mfaConfiguration: Optional MFA configuration
    ///   - onIdentityCreationSuccess: Optional callback when identity is created
    /// - Returns: A configured Identity Backend Client with Mailgun email sending
    public static func mailgun(
        business: BusinessDetails,
        router: AnyParserPrinter<URLRequestData, Identity.Route>,
        mfaConfiguration: Identity.MFA.TOTP.Configuration? = nil,
        onIdentityCreationSuccess: @escaping @Sendable (_ identity: (id: UUID, email: EmailAddress)) async throws -> Void = { _ in }
    ) -> Self {
        @Dependency(\.mailgun) var mailgun
        @Dependency(\.logger) var logger
        
        return .mailgun(
            business: business,
            router: router,
            sendEmail: { request in
                do {
                    let response = try await mailgun.client.messages.send(request)
                    logger.info("Email sent successfully", metadata: [
                        "messageId": "\(response.id)",
                        "to": "\(request.to.map(\.rawValue).joined(separator: ", "))"
                    ])
                } catch {
                    logger.error("Failed to send email", metadata: [
                        "error": "\(error)",
                        "to": "\(request.to.map(\.rawValue).joined(separator: ", "))"
                    ])
                    throw error
                }
            },
            mfaConfiguration: mfaConfiguration,
            onIdentityCreationSuccess: onIdentityCreationSuccess
        )
    }
    
    /// Creates a logging-only Identity Backend Client for development/testing.
    ///
    /// This implementation logs all email operations without actually sending emails.
    /// Useful for local development and testing without Mailgun configuration.
    ///
    /// - Parameters:
    ///   - business: Business details for email branding and configuration
    ///   - router: Router for generating URLs in emails
    ///   - mfaConfiguration: Optional MFA configuration
    /// - Returns: A configured Identity Backend Client that only logs email operations
    public static func mailgunLogging(
        business: BusinessDetails,
        router: AnyParserPrinter<URLRequestData, Identity.Route>,
        mfaConfiguration: Identity.MFA.TOTP.Configuration? = nil
    ) -> Self {
        @Dependency(\.logger) var logger
        
        return .mailgun(
            business: business,
            router: router,
            sendEmail: { request in
                logger.info("Demo: Email would be sent", metadata: [
                    "from": "\(request.from.rawValue)",
                    "to": "\(request.to.map(\.rawValue).joined(separator: ", "))",
                    "subject": "\(request.subject)",
                    "hasHtml": "\(request.html != nil)",
                    "hasText": "\(request.text != nil)"
                ])
                
                // Log the content for debugging
                if let html = request.html {
                    logger.debug("Email HTML content", metadata: [
                        "htmlLength": "\(html.count)"
                    ])
                }
                
                if let text = request.text {
                    logger.debug("Email text content", metadata: [
                        "text": "\(text)"
                    ])
                }
            },
            mfaConfiguration: mfaConfiguration,
            onIdentityCreationSuccess: { identity in
                logger.notice("Demo: Identity created successfully", metadata: [
                    "identityId": "\(identity.id)",
                    "email": "\(identity.email)"
                ])
            }
        )
    }
}
