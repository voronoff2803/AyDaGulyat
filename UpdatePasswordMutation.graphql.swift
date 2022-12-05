// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
import Aida

public class UpdatePasswordMutation: GraphQLMutation {
  public static let operationName: String = "UpdatePassword"
  public static let document: DocumentType = .notPersisted(
    definition: .init(
      """
      mutation UpdatePassword($newPassword: String!, $oldPassword: String!) {
        updatePassword(newPassword: $newPassword, oldPassword: $oldPassword) {
          __typename
          success
          id
        }
      }
      """
    ))

  public var newPassword: String
  public var oldPassword: String

  public init(
    newPassword: String,
    oldPassword: String
  ) {
    self.newPassword = newPassword
    self.oldPassword = oldPassword
  }

  public var __variables: Variables? { [
    "newPassword": newPassword,
    "oldPassword": oldPassword
  ] }

  public struct Data: Aida.SelectionSet {
    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ParentType { Aida.Objects.Mutation }
    public static var __selections: [Selection] { [
      .field("updatePassword", UpdatePassword?.self, arguments: [
        "newPassword": .variable("newPassword"),
        "oldPassword": .variable("oldPassword")
      ]),
    ] }

    /// User password update mutation
    public var updatePassword: UpdatePassword? { __data["updatePassword"] }

    /// UpdatePassword
    ///
    /// Parent Type: `UpdatePassword`
    public struct UpdatePassword: Aida.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ParentType { Aida.Objects.UpdatePassword }
      public static var __selections: [Selection] { [
        .field("success", Bool.self),
        .field("id", Aida.UUID?.self),
      ] }

      public var success: Bool { __data["success"] }
      public var id: Aida.UUID? { __data["id"] }
    }
  }
}
