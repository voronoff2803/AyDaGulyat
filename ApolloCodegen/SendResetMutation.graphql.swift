// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
import Aida

public class SendResetMutation: GraphQLMutation {
  public static let operationName: String = "SendReset"
  public static let document: DocumentType = .notPersisted(
    definition: .init(
      """
      mutation SendReset($email: String!) {
        sendReset(email: $email) {
          __typename
          success
          id
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
      .field("sendReset", SendReset?.self, arguments: ["email": .variable("email")]),
    ] }

    /// Send password reset email to the user
    public var sendReset: SendReset? { __data["sendReset"] }

    /// SendReset
    ///
    /// Parent Type: `SendPasswordReset`
    public struct SendReset: Aida.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ParentType { Aida.Objects.SendPasswordReset }
      public static var __selections: [Selection] { [
        .field("success", Bool.self),
        .field("id", Aida.UUID?.self),
      ] }

      public var success: Bool { __data["success"] }
      public var id: Aida.UUID? { __data["id"] }
    }
  }
}
