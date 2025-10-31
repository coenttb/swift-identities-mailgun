# swift-identities-mailgun

[![CI](https://github.com/coenttb/swift-identities-mailgun/workflows/CI/badge.svg)](https://github.com/coenttb/swift-identities-mailgun/actions/workflows/ci.yml)
![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

A Swift package that provides Mailgun email integration for [swift-identities](https://github.com/coenttb/swift-identities) authentication system.

## Overview

This package bridges the gap between swift-identities authentication system and Mailgun email service, providing ready-to-use email templates for all identity-related communications.

## Features

- Email verification with 24-hour expiration
- Password reset and change notifications
- Email address change confirmations
- Account deletion notifications
- Multi-language support (Dutch/English)
- Type-safe HTML templates via swift-html
- Dependency injection via swift-dependencies

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
import ServerFoundation

// Configure your business details
let business = BusinessDetails(
    name: "MyApp",
    supportEmail: try EmailAddress("support@myapp.com"),
    fromEmail: try EmailAddress("noreply@myapp.com")
)

// Create the email configuration with Mailgun integration
let emailConfig = Identity.Backend.Configuration.Email.mailgun(
    business: business,
    router: identityRouter
)

// Use in your Identity.Backend.Configuration or Identity.Standalone.Configuration
```

### Development/Testing with Logging

For local development without sending actual emails:

```swift
let emailConfig = Identity.Backend.Configuration.Email.mailgunLogging(
    business: business,
    router: identityRouter
)
// This will log all email operations without sending emails
```

### Custom Email Sending

If you need more control over the email sending process:

```swift
let emailConfig = Identity.Backend.Configuration.Email.mailgun(
    business: business,
    router: identityRouter,
    sendEmail: { request in
        // Custom email sending logic
        try await myCustomMailgunClient.send(request)
    }
)
```

## Email Templates

All email templates are built using type-safe HTML DSL from swift-html and include professional, responsive design with multi-language support, clear call-to-action buttons, security notices, and support contact information.

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
  - swift-html

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
