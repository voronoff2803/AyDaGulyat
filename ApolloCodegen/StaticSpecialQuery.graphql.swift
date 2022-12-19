// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
import Aida

public class StaticSpecialQuery: GraphQLQuery {
  public static let operationName: String = "StaticSpecial"
  public static let document: DocumentType = .notPersisted(
    definition: .init(
      """
      query StaticSpecial {
        staticSpecial {
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
      .field("staticSpecial", [StaticSpecial?]?.self),
    ] }

    public var staticSpecial: [StaticSpecial?]? { __data["staticSpecial"] }

    /// StaticSpecial
    ///
    /// Parent Type: `StaticDataDogSpecialization`
    public struct StaticSpecial: Aida.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ParentType { Aida.Objects.StaticDataDogSpecialization }
      public static var __selections: [Selection] { [
        .field("id", Aida.UUID.self),
        .field("valueRu", String.self),
      ] }

      public var id: Aida.UUID { __data["id"] }
      public var valueRu: String { __data["valueRu"] }
    }
  }
}
