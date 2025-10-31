# swift-identities-mailgun

[![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![License](https://img.shields.io/badge/License-AGPL%203.0-blue.svg)](LICENSE.md)
[![Version](https://img.shields.io/badge/version-0.1.0-green.svg)](https://github.com/coenttb/swift-identities-mailgun/releases)

A Swift package that provides Mailgun email integration for [swift-identities](https://github.com/coenttb/swift-identities) authentication system.

## Overview

This package bridges the gap between swift-identities authentication system and Mailgun email service, providing ready-to-use email templates for all identity-related communications:

- ✅ Email verification
- 🔐 Password reset and change notifications
- 📧 Email address change confirmations
- 🗑️ Account deletion notifications
- 🌍 Multi-language support (Dutch/English)

## Installation

Add this package to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/coenttb/swift-identities-mailgun", from: "0.1.0")
]
```

## Usage

### Basic Setup with Live Mailgun

```swift
import IdentitiesMailgunLive
import Dependencies

// Configure your business details
let business = BusinessDetails(
    name: "MyApp",
    supportEmail: "support@myapp.com",
    fromEmail: "noreply@myapp.com"
)

// Create the identity client with Mailgun integration
let identityClient = Identity.Client.mailgun(
    business: business,
    router: identityRouter
)

// The client will automatically use the Mailgun dependency
// configured in your application
```

### Development/Testing with Logging

For local development without sending actual emails:

```swift
let identityClient = Identity.Client.mailgunLogging(
    business: business,
    router: identityRouter
)
// This will log all email operations without sending emails
```

### Custom Email Sending

If you need more control over the email sending process:

```swift
let identityClient = Identity.Client.mailgun(
    business: business,
    router: identityRouter,
    sendEmail: { request in
        // Custom email sending logic
        try await myCustomMailgunClient.send(request)
    }
)
```

## Email Templates

All email templates are built using type-safe HTML DSL from `coenttb-html` and include:

- Professional, responsive design
- Multi-language support (Dutch/English)
- Clear call-to-action buttons
- Security notices where appropriate
- Support contact information

### Available Templates

#### Email Verification
- Sent when a new user registers
- Contains verification link
- 24-hour expiration notice

#### Password Reset
- Request email with reset link
- Confirmation after successful reset
- Change notification for security

#### Email Change
- Request notification to current email
- Verification request to new email
- Success notifications to both addresses

#### Account Deletion
- Request confirmation with 30-day notice
- Final confirmation after deletion

## Architecture

The package is organized into two main modules:

### IdentitiesMailgun
Core types and email templates:
- `BusinessDetails` - Configuration for business branding
- Email template functions as Mailgun.Messages.Send.Request extensions
- Integration with Identity.Client

### IdentitiesMailgunLive
Live implementation with dependency injection:
- Automatic Mailgun client integration via Dependencies
- Logging implementation for development
- Error handling and retry logic

## Requirements

- Swift 6.0+
- macOS 14+ / iOS 17+
- Dependencies:
  - swift-identities
  - swift-mailgun
  - swift-dependencies
  - coenttb-html

## Related Packages

### Dependencies

- [swift-html](https://github.com/coenttb/swift-html): The Swift library for domain-accurate and type-safe HTML & CSS.
- [swift-identities](https://github.com/coenttb/swift-identities): The Swift library for identity authentication and management.
- [swift-identities-types](https://github.com/coenttb/swift-identities-types): A Swift package with foundational types for authentication.
- [swift-mailgun](https://github.com/coenttb/swift-mailgun): The Swift library for the Mailgun API.
- [swift-server-foundation](https://github.com/coenttb/swift-server-foundation): A Swift package with tools to simplify server development.

### Third-Party Dependencies

- [pointfreeco/swift-dependencies](https://github.com/pointfreeco/swift-dependencies): A dependency management library for controlling dependencies in Swift.

## License

This package follows the licensing structure of the coenttb ecosystem. See LICENSE file for details.
