// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
import Aida

public class StaticHobbyQuery: GraphQLQuery {
  public static let operationName: String = "StaticHobby"
  public static let document: DocumentType = .notPersisted(
    definition: .init(
      """
      query StaticHobby {
        staticHobby {
          __typename
          id
          valueRu
        }
      }
      """
    ))

  public init() {}

  public struct Data: Aida.SelectionSet {
    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ParentType { Aida.Objects.Query }
    public static var __selections: [Selection] { [
      .field("staticHobby", [StaticHobby?]?.self),
    ] }

    public var staticHobby: [StaticHobby?]? { __data["staticHobby"] }

    /// StaticHobby
    ///
    /// Parent Type: `StaticDataHobby`
    public struct StaticHobby: Aida.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ParentType { Aida.Objects.StaticDataHobby }
      public static var __selections: [Selection] { [
        .field("id", Aida.UUID.self),
        .field("valueRu", String.self),
      ] }

      public var id: Aida.UUID { __data["id"] }
      public var valueRu: String { __data["valueRu"] }
    }
  }
}
