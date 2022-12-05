// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
import Aida

public class SendCodeMutation: GraphQLMutation {
  public static let operationName: String = "SendCode"
  public static let document: DocumentType = .notPersisted(
    definition: .init(
      """
      mutation SendCode($id: UUID) {
        sendCode(id: $id) {
          __typename
          success
          id
        }
      }
      """
    ))

  public var id: GraphQLNullable<Aida.UUID>

  public init(id: GraphQLNullable<Aida.UUID>) {
    self.id = id
  }

  public var __variables: Variables? { ["id": id] }

  public struct Data: Aida.SelectionSet {
    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ParentType { Aida.Objects.Mutation }
    public static var __selections: [Selection] { [
      .field("sendCode", SendCode?.self, arguments: ["id": .variable("id")]),
    ] }

    /// Valudation code (re)send
    public var sendCode: SendCode? { __data["sendCode"] }

    /// SendCode
    ///
    /// Parent Type: `ResendValidationCode`
    public struct SendCode: Aida.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ParentType { Aida.Objects.ResendValidationCode }
      public static var __selections: [Selection] { [
        .field("success", Bool.self),
        .field("id", Aida.UUID?.self),
      ] }

      public var success: Bool { __data["success"] }
      public var id: Aida.UUID? { __data["id"] }
    }
  }
}
