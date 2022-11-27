// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
import Aida

public class ResetPasswordMutation: GraphQLMutation {
  public static let operationName: String = "ResetPassword"
  public static let document: DocumentType = .notPersisted(
    definition: .init(
      """
      mutation ResetPassword($email: String!) {
        resetPassword(email: $email) {
          __typename
          id
          success
        }
      }
      """
    ))

  public var email: String

  public init(email: String) {
    self.email = email
  }

  public var __variables: Variables? { ["email": email] }

  public struct Data: Aida.SelectionSet {
    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ParentType { Aida.Objects.Mutation }
    public static var __selections: [Selection] { [
      .field("resetPassword", ResetPassword?.self, arguments: ["email": .variable("email")]),
    ] }

    /// Send password reset email to the user
    public var resetPassword: ResetPassword? { __data["resetPassword"] }

    /// ResetPassword
    ///
    /// Parent Type: `SendPasswordReset`
    public struct ResetPassword: Aida.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ParentType { Aida.Objects.SendPasswordReset }
      public static var __selections: [Selection] { [
        .field("id", Aida.UUID?.self),
        .field("success", Bool?.self),
      ] }

      public var id: Aida.UUID? { __data["id"] }
      public var success: Bool? { __data["success"] }
    }
  }
}
