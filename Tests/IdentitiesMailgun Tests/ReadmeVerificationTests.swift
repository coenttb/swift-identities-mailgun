//
//  ReadmeVerificationTests.swift
//  swift-identities-mailgun
//
//  README code example verification tests
//

import Testing
import IdentitiesMailgun
import IdentitiesMailgunLive
import Dependencies
import ServerFoundation
import IdentitiesTypes
import Identity_Backend

@Suite("README Verification")
struct ReadmeVerificationTests {

    @Test("BusinessDetails initialization - README line 42-46")
    func businessDetailsExample() throws {
        // Example from README - Basic Setup with Live Mailgun
        let business = BusinessDetails(
            name: "MyApp",
            supportEmail: try EmailAddress("support@myapp.com"),
            fromEmail: try EmailAddress("noreply@myapp.com")
        )

        #expect(business.name == "MyApp")
        #expect(business.supportEmail.rawValue == "support@myapp.com")
        #expect(business.fromEmail.rawValue == "noreply@myapp.com")
    }

    @Test("Email configuration type exists")
    func emailConfigurationType() throws {
        // Verify Identity.Backend.Configuration.Email type exists
        let _: Identity.Backend.Configuration.Email.Type = Identity.Backend.Configuration.Email.self
    }
}
