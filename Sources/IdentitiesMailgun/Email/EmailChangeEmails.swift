//
//  EmailChangeEmails.swift
//  swift-identities-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 30/08/2025.
//

import Foundation
import IdentitiesTypes
import Mailgun_Messages_Types
import CoenttbEmail
import CoenttbHTML
import ServerFoundation

// MARK: - Email Change Request Notification

extension Mailgun.Messages.Send.Request {
    public static func emailChangeRequestNotification(
        currentEmail: EmailAddress,
        newEmail: EmailAddress,
        business: BusinessDetails
    ) throws -> Self {
        let subject = TranslatedString(
            dutch: "Belangrijk: Verzoek tot e-mailwijziging ontvangen",
            english: "Important: Email Change Request Received"
        )
        
        return try .init(
            from: business.fromEmail,
            to: [ currentEmail ],
            subject: "\(business.name) | \(subject)",
            text: nil
        ) {
            TableEmailDocument(
                preheader: TranslatedString(
                    dutch: "Er is een verzoek ingediend om je e-mailadres te wijzigen voor \(business.name)",
                    english: "A request has been made to change your email address for \(business.name)"
                ).description
            ) {
                tr {
                    td {
                        VStack(alignment: .start) {
                            Header(3) {
                                TranslatedString(
                                    dutch: "Verzoek tot e-mailwijziging ontvangen",
                                    english: "Email Change Request Received"
                                )
                            }
                            
                            CoenttbHTML.Paragraph {
                                TranslatedString(
                                    dutch: "We hebben een verzoek ontvangen om het e-mailadres voor je \(business.name) account te wijzigen van \(currentEmail) naar \(newEmail).",
                                    english: "We received a request to change the email address for your \(business.name) account from \(currentEmail) to \(newEmail)."
                                )
                            }
                            .padding(bottom: .extraSmall)
                            .font(.body)
                            
                            CoenttbHTML.Paragraph {
                                TranslatedString(
                                    dutch: "Als je dit verzoek hebt gedaan, hoef je verder niets te doen. De wijziging wordt binnenkort doorgevoerd.",
                                    english: "If you made this request, no further action is needed. The change will be processed shortly."
                                )
                            }
                            .padding(bottom: .extraSmall)
                            .font(.body)
                            
                            CoenttbHTML.Paragraph(.small) {
                                TranslatedString(
                                    dutch: "Als je dit verzoek niet hebt gedaan, neem dan onmiddellijk contact op met ons via \(business.supportEmail) om je account te beveiligen.",
                                    english: "If you didn't request this change, please contact us immediately at \(business.supportEmail) to secure your account."
                                )
                            }
                            .font(.footnote)
                            .color(.text.secondary)
                        }
                        .padding(vertical: .small, horizontal: .medium)
                    }
                }
            }
            .backgroundColor(.background.primary.reverse())
        }
    }
}

// MARK: - Email Change Confirmation Request

extension Mailgun.Messages.Send.Request {
    public static func emailChangeConfirmationRequest(
        verificationURL: URL,
        currentEmail: EmailAddress,
        newEmail: EmailAddress,
        business: BusinessDetails
    ) throws -> Self {
        let subject = TranslatedString(
            dutch: "Verifieer je e-mailadres",
            english: "Verify your email address"
        )
        
        return try .init(
            from: business.fromEmail,
            to: [ newEmail ],
            subject: "\(business.name) | \(subject)",
            text: nil
        ) {
            TableEmailDocument(
                preheader: TranslatedString(
                    dutch: "Verifieer je nieuwe e-mailadres voor \(business.name)",
                    english: "Verify your new email address for \(business.name)"
                ).description
            ) {
                tr {
                    td {
                        VStack(alignment: .start) {
                            Header(3) {
                                TranslatedString(
                                    dutch: "Verifieer je nieuwe e-mailadres",
                                    english: "Verify your new email address"
                                )
                            }
                            
                            CoenttbHTML.Paragraph {
                                TranslatedString(
                                    dutch: "We hebben een verzoek ontvangen om het e-mailadres voor je \(business.name) account te wijzigen. Klik op de onderstaande knop om je nieuwe e-mailadres te verifiëren.",
                                    english: "We received a request to change the email address for your \(business.name) account. Click the button below to verify your new email address."
                                )
                            }
                            .padding(bottom: .extraSmall)
                            .font(.body)
                            
                            Link(href: .init(value: verificationURL.absoluteString)) {
                                TranslatedString(
                                    dutch: "Verifieer e-mailadres",
                                    english: "Verify email address"
                                )
                            }
                            .color(.text.primary.reverse())
                            .padding(bottom: .medium)
                            
                            CoenttbHTML.Paragraph(.small) {
                                TranslatedString(
                                    dutch: "Deze link verloopt binnen 1 uur om veiligheidsredenen.",
                                    english: "This link will expire in 1 hour for security reasons."
                                )
                            }
                            .font(.footnote)
                            .color(.text.secondary)
                            
                            CoenttbHTML.Paragraph(.small) {
                                TranslatedString(
                                    dutch: "Als je geen wijziging van je e-mailadres hebt aangevraagd, kun je deze e-mail negeren.",
                                    english: "If you didn't request an email address change, you can ignore this email."
                                )
                            }
                            .font(.footnote)
                            .color(.text.secondary)
                            
                            CoenttbHTML.Paragraph(.small) {
                                TranslatedString(
                                    dutch: "Voor hulp, neem contact op met ons via \(business.supportEmail).",
                                    english: "For help, contact us at \(business.supportEmail)."
                                )
                            }
                            .font(.footnote)
                            .color(.text.secondary)
                        }
                        .padding(vertical: .small, horizontal: .medium)
                    }
                }
            }
            .backgroundColor(.background.primary.reverse())
        }
    }
}

// MARK: - Email Change Success Notification (to old email)

extension Mailgun.Messages.Send.Request {
    public static func emailChangeSuccessToOldEmail(
        currentEmail: EmailAddress,
        newEmail: EmailAddress,
        business: BusinessDetails
    ) throws -> Self {
        let subject = TranslatedString(
            dutch: "Belangrijk: Je e-mailadres is gewijzigd",
            english: "Important: Your email address has been changed"
        )
        
        return try .init(
            from: business.fromEmail,
            to: [ currentEmail ],
            subject: "\(business.name) | \(subject)",
            text: nil
        ) {
            TableEmailDocument(
                preheader: TranslatedString(
                    dutch: "Je e-mailadres voor \(business.name) is gewijzigd",
                    english: "Your email address for \(business.name) has been changed"
                ).description
            ) {
                tr {
                    td {
                        VStack(alignment: .start) {
                            Header(3) {
                                TranslatedString(
                                    dutch: "Je e-mailadres is gewijzigd",
                                    english: "Your email address has been changed"
                                )
                            }
                            
                            CoenttbHTML.Paragraph {
                                TranslatedString(
                                    dutch: "We willen je informeren dat het e-mailadres voor je \(business.name) account is gewijzigd van \(currentEmail.rawValue) naar \(newEmail.rawValue).",
                                    english: "We're informing you that the email address for your \(business.name) account has been changed from \(currentEmail.rawValue) to \(newEmail.rawValue)."
                                )
                            }
                            .padding(bottom: .extraSmall)
                            .font(.body)
                            
                            CoenttbHTML.Paragraph {
                                TranslatedString(
                                    dutch: "Als je deze wijziging hebt aangevraagd, kun je deze e-mail als bevestiging beschouwen. Je kunt nu inloggen met je nieuwe e-mailadres.",
                                    english: "If you requested this change, please consider this email as confirmation. You can now log in using your new email address."
                                )
                            }
                            .padding(bottom: .extraSmall)
                            .font(.body)
                            
                            CoenttbHTML.Paragraph(.small) {
                                TranslatedString(
                                    dutch: "Als je deze wijziging niet hebt aangevraagd, neem dan onmiddellijk contact op met ons via \(business.supportEmail) om je account te beveiligen.",
                                    english: "If you didn't request this change, please contact us immediately at \(business.supportEmail) to secure your account."
                                )
                            }
                            .font(.footnote)
                            .color(.text.secondary)
                        }
                        .padding(vertical: .small, horizontal: .medium)
                    }
                }
            }
            .backgroundColor(.background.primary.reverse())
        }
    }
}

// MARK: - Email Change Success Notification (to new email)

extension Mailgun.Messages.Send.Request {
    public static func emailChangeSuccessToNewEmail(
        currentEmail: EmailAddress,
        newEmail: EmailAddress,
        business: BusinessDetails
    ) throws -> Self {
        let subject = TranslatedString(
            dutch: "Je nieuwe e-mailadres is bevestigd",
            english: "Your new email address is confirmed"
        )
        
        return try .init(
            from: business.fromEmail,
            to: [ newEmail ],
            subject: "\(business.name) | \(subject)",
            text: nil
        ) {
            TableEmailDocument(
                preheader: TranslatedString(
                    dutch: "Je nieuwe e-mailadres voor \(business.name) is bevestigd",
                    english: "Your new email address for \(business.name) is confirmed"
                ).description
            ) {
                tr {
                    td {
                        VStack(alignment: .start) {
                            Header(3) {
                                TranslatedString(
                                    dutch: "Je nieuwe e-mailadres is bevestigd",
                                    english: "Your new email address is confirmed"
                                )
                            }
                            
                            CoenttbHTML.Paragraph {
                                TranslatedString(
                                    dutch: "Welkom! We bevestigen dat dit e-mailadres (\(newEmail.rawValue)) nu is gekoppeld aan je \(business.name) account. Je vorige e-mailadres was \(currentEmail.rawValue).",
                                    english: "Welcome! We confirm that this email address (\(newEmail.rawValue)) is now associated with your \(business.name) account. Your previous email address was \(currentEmail.rawValue)."
                                )
                            }
                            .padding(bottom: .extraSmall)
                            .font(.body)
                            
                            CoenttbHTML.Paragraph {
                                TranslatedString(
                                    dutch: "Je kunt nu inloggen op je account met dit nieuwe e-mailadres. Al je accountgegevens en voorkeuren blijven ongewijzigd.",
                                    english: "You can now log in to your account using this new email address. All your account details and preferences remain unchanged."
                                )
                            }
                            .padding(bottom: .extraSmall)
                            .font(.body)
                            
                            CoenttbHTML.Paragraph(.small) {
                                TranslatedString(
                                    dutch: "Als je deze wijziging niet hebt aangevraagd of als je vragen hebt, neem dan contact op met ons via \(business.supportEmail).",
                                    english: "If you didn't request this change or if you have any questions, please contact us at \(business.supportEmail)."
                                )
                            }
                            .font(.footnote)
                            .color(.text.secondary)
                        }
                        .padding(vertical: .small, horizontal: .medium)
                    }
                }
            }
            .backgroundColor(.background.primary.reverse())
        }
    }
}