//
//  Identity.Client+Mailgun.swift
//  swift-identities-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 30/08/2025.
//

import Foundation
import IdentitiesTypes
import Identity_Backend
import ServerFoundation

extension Identity.Client {
    /// Creates an Identity Backend Client that uses Mailgun for sending emails.
    ///
    /// This convenience method creates a client configured with Mailgun email templates
    /// for all identity-related email communications.
    ///
    /// - Parameters:
    ///   - business: Business details for email branding and configuration
    ///   - router: Router for generating URLs in emails
    ///   - sendEmail: Closure to actually send the email via Mailgun
    ///   - mfaConfiguration: Optional MFA configuration
    ///   - onIdentityCreationSuccess: Optional callback when identity is created
    /// - Returns: A configured Identity Backend Client
    public static func mailgun(
        business: BusinessDetails,
        router: AnyParserPrinter<URLRequestData, Identity.Route>,
        sendEmail: @escaping @Sendable (Mailgun.Messages.Send.Request) async throws -> Void,
        mfaConfiguration: Identity.MFA.TOTP.Configuration? = nil,
        onIdentityCreationSuccess: @escaping @Sendable (_ identity: (id: Identity.ID, email: EmailAddress)) async throws -> Void = { _ in }
    ) -> Self {
        return .live(
            sendVerificationEmail: { email, token in
                let verificationUrl = router.url(for: .view(.create(.verify(.init(token: token, email: email.rawValue)))))
                let request = try Mailgun.Messages.Send.Request.requestEmailVerification(
                    verificationUrl: verificationUrl,
                    business: business,
                    to: email
                )
                try await sendEmail(request)
            },
            sendPasswordResetEmail: { email, token in
                let resetUrl = router.url(for: .view(.password(.reset(.confirm(.init(token: token))))))
                let request = try Mailgun.Messages.Send.Request.passwordResetRequest(
                    resetUrl: resetUrl,
                    business: business,
                    to: email
                )
                try await sendEmail(request)
            },
            sendPasswordChangeNotification: { email in
                let request = try Mailgun.Messages.Send.Request.passwordChangeNotification(
                    business: business,
                    to: email
                )
                try await sendEmail(request)
            },
            sendEmailChangeConfirmation: { currentEmail, newEmail, token in
                let verificationURL = router.url(for: .api(.email(.change(.confirm(.init(token: token))))))
                let request = try Mailgun.Messages.Send.Request.emailChangeConfirmationRequest(
                    verificationURL: verificationURL,
                    currentEmail: currentEmail,
                    newEmail: newEmail,
                    business: business
                )
                try await sendEmail(request)
            },
            sendEmailChangeRequestNotification: { currentEmail, newEmail in
                let request = try Mailgun.Messages.Send.Request.emailChangeRequestNotification(
                    currentEmail: currentEmail,
                    newEmail: newEmail,
                    business: business
                )
                try await sendEmail(request)
            },
            onEmailChangeSuccess: { currentEmail, newEmail in
                // Send notification to old email
                let oldEmailRequest = try Mailgun.Messages.Send.Request.emailChangeSuccessToOldEmail(
                    currentEmail: currentEmail,
                    newEmail: newEmail,
                    business: business
                )
                try await sendEmail(oldEmailRequest)
                
                // Send welcome to new email
                let newEmailRequest = try Mailgun.Messages.Send.Request.emailChangeSuccessToNewEmail(
                    currentEmail: currentEmail,
                    newEmail: newEmail,
                    business: business
                )
                try await sendEmail(newEmailRequest)
            },
            sendDeletionRequestNotification: { email in
                let request = try Mailgun.Messages.Send.Request.deletionRequestNotification(
                    email: email,
                    business: business
                )
                try await sendEmail(request)
            },
            sendDeletionConfirmationNotification: { email in
                let request = try Mailgun.Messages.Send.Request.deletionConfirmationNotification(
                    email: email,
                    business: business
                )
                try await sendEmail(request)
            },
            onIdentityCreationSuccess: onIdentityCreationSuccess,
            mfaConfiguration: mfaConfiguration
        )
    }
}
