//
//  PasswordEmail.swift
//  swift-identities-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 30/08/2025.
//

import Foundation
import HTML
import HTMLEmail
import HTMLWebsite
import IdentitiesTypes
import Mailgun_Messages_Types
import ServerFoundation

// MARK: - Password Reset Request

extension Mailgun.Messages.Send.Request {
  public static func passwordResetRequest(
    resetUrl: URL,
    business: BusinessDetails,
    to user: EmailAddress
  ) throws -> Self {
    let subject = TranslatedString(
      dutch: "Reset je wachtwoord",
      english: "Reset your password"
    )

    return try .init(
      from: business.fromEmail,
      to: [user],
      subject: "\(business.name) | \(subject)",
      text: nil
    ) {
      TableEmailDocument(
        preheader: TranslatedString(
          dutch: "Reset je wachtwoord voor \(business.name)",
          english: "Reset your password for \(business.name)"
        ).description
      ) {
        tr {
          td {
            VStack(alignment: .start) {
              Header(3) {
                TranslatedString(
                  dutch: "Reset je wachtwoord",
                  english: "Reset your password"
                )
              }

              HTMLComponents.Paragraph {
                TranslatedString(
                  dutch:
                    "We hebben een verzoek ontvangen om het wachtwoord voor je \(business.name) account te resetten. Klik op de onderstaande knop om je wachtwoord te wijzigen.",
                  english:
                    "We received a request to reset the password for your \(business.name) account. Click the button below to change your password."
                )
              }
              .padding(bottom: .extraSmall)
              .font(.body)

              Link(href: .init(value: resetUrl.absoluteString)) {
                TranslatedString(
                  dutch: "Reset wachtwoord",
                  english: "Reset password"
                )
              }
              .color(.text.primary.reverse())
              .padding(bottom: .medium)

              HTMLComponents.Paragraph(.small) {
                TranslatedString(
                  dutch: "Om veiligheidsredenen verloopt deze link binnen 1 uur.",
                  english: "This link will expire in 1 hour for security reasons."
                )
              }
              .font(.footnote)
              .color(.text.secondary)

              HTMLComponents.Paragraph(.small) {
                TranslatedString(
                  dutch:
                    "Als je geen wachtwoordreset hebt aangevraagd, kun je deze e-mail negeren.",
                  english: "If you didn't request a password reset, you can ignore this email."
                )
              }
              .font(.footnote)
              .color(.text.secondary)

              HTMLComponents.Paragraph(.small) {
                TranslatedString(
                  dutch: "Voor hulp, neem contact op met ons op via \(business.supportEmail).",
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

// MARK: - Password Reset Confirmation

extension Mailgun.Messages.Send.Request {
  public static func passwordResetConfirmation(
    business: BusinessDetails,
    to user: EmailAddress
  ) throws -> Self {
    let subject = TranslatedString(
      dutch: "Wachtwoord succesvol gereset",
      english: "Password Successfully Reset"
    )

    return try .init(
      from: business.fromEmail,
      to: [user],
      subject: "\(business.name) | \(subject)",
      text: nil
    ) {
      TableEmailDocument(
        preheader: TranslatedString(
          dutch: "Je wachtwoord is succesvol gereset voor \(business.name)",
          english: "Your password has been successfully reset for \(business.name)"
        ).description
      ) {
        tr {
          td {
            VStack(alignment: .start) {
              Header(3) {
                TranslatedString(
                  dutch: "Wachtwoord succesvol gereset",
                  english: "Password Successfully Reset"
                )
              }

              HTMLComponents.Paragraph {
                TranslatedString(
                  dutch:
                    "We bevestigen dat je wachtwoord voor je \(business.name) account succesvol is gereset.",
                  english:
                    "We confirm that the password for your \(business.name) account has been successfully reset."
                )
              }
              .padding(bottom: .extraSmall)
              .font(.body)

              HTMLComponents.Paragraph {
                TranslatedString(
                  dutch: "Je kunt nu inloggen met je nieuwe wachtwoord.",
                  english: "You can now log in using your new password."
                )
              }
              .padding(bottom: .extraSmall)
              .font(.body)

              HTMLComponents.Paragraph(.small) {
                TranslatedString(
                  dutch:
                    "Als je deze wijziging niet hebt aangevraagd, neem dan onmiddellijk contact op met ons via \(business.supportEmail) om je account te beveiligen.",
                  english:
                    "If you didn't request this change, please contact us immediately at \(business.supportEmail) to secure your account."
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

// MARK: - Password Change Notification

extension Mailgun.Messages.Send.Request {
  public static func passwordChangeNotification(
    business: BusinessDetails,
    to user: EmailAddress
  ) throws -> Self {
    let subject = TranslatedString(
      dutch: "Wachtwoord gewijzigd",
      english: "Password Changed"
    )

    return try .init(
      from: business.fromEmail,
      to: [user],
      subject: "\(business.name) | \(subject)",
      text: nil
    ) {
      TableEmailDocument(
        preheader: TranslatedString(
          dutch: "Je wachtwoord is gewijzigd voor \(business.name)",
          english: "Your password has been changed for \(business.name)"
        ).description
      ) {
        tr {
          td {
            VStack(alignment: .start) {
              Header(3) {
                TranslatedString(
                  dutch: "Wachtwoord gewijzigd",
                  english: "Password Changed"
                )
              }

              HTMLComponents.Paragraph {
                TranslatedString(
                  dutch:
                    "We willen je informeren dat het wachtwoord voor je \(business.name) account zojuist is gewijzigd.",
                  english:
                    "We're writing to inform you that the password for your \(business.name) account has just been changed."
                )
              }
              .padding(bottom: .extraSmall)
              .font(.body)

              HTMLComponents.Paragraph {
                TranslatedString(
                  dutch:
                    "Als je deze wijziging hebt aangevraagd, kun je deze e-mail als bevestiging beschouwen.",
                  english:
                    "If you requested this change, please consider this email as confirmation."
                )
              }
              .padding(bottom: .extraSmall)
              .font(.body)

              HTMLComponents.Paragraph(.small) {
                TranslatedString(
                  dutch:
                    "Als je deze wijziging niet hebt aangevraagd, neem dan onmiddellijk contact op met ons via \(business.supportEmail) om je account te beveiligen.",
                  english:
                    "If you didn't request this change, please contact us immediately at \(business.supportEmail) to secure your account."
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
