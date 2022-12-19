// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
import Aida

public class StaticDangerQuery: GraphQLQuery {
  public static let operationName: String = "StaticDanger"
  public static let document: DocumentType = .notPersisted(
    definition: .init(
      """
      query StaticDanger {
        staticDanger {
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
      .field("staticDanger", [StaticDanger?]?.self),
    ] }

    public var staticDanger: [StaticDanger?]? { __data["staticDanger"] }

    /// StaticDanger
    ///
    /// Parent Type: `StaticDataDanger`
    public struct StaticDanger: Aida.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ParentType { Aida.Objects.StaticDataDanger }
      public static var __selections: [Selection] { [
        .field("id", Aida.UUID.self),
        .field("valueRu", String.self),
      ] }

      public var id: Aida.UUID { __data["id"] }
      public var valueRu: String { __data["valueRu"] }
    }
  }
}
