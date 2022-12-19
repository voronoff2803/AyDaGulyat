// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
import Aida

public class ResetPasswordMutation: GraphQLMutation {
  public static let operationName: String = "ResetPassword"
  public static let document: DocumentType = .notPersisted(
    definition: .init(
      """
      mutation ResetPassword($newPassword: String!) {
        resetPassword(newPassword: $newPassword) {
          __typename
          success
          id
        }
      }
      """
    ))

  public var newPassword: String

  public init(newPassword: String) {
    self.newPassword = newPassword
  }

  public var __variables: Variables? { ["newPassword": newPassword] }

  public struct Data: Aida.SelectionSet {
    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ParentType { Aida.Objects.Mutation }
    public static var __selections: [Selection] { [
      .field("resetPassword", ResetPassword?.self, arguments: ["newPassword": .variable("newPassword")]),
    ] }

    /// User password reset (available via reset token)
    public var resetPassword: ResetPassword? { __data["resetPassword"] }

    /// ResetPassword
    ///
    /// Parent Type: `ResetPassword`
    public struct ResetPassword: Aida.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ParentType { Aida.Objects.ResetPassword }
      public static var __selections: [Selection] { [
        .field("success", Bool.self),
        .field("id", Aida.UUID?.self),
      ] }

      public var success: Bool { __data["success"] }
      public var id: Aida.UUID? { __data["id"] }
    }
  }
}
