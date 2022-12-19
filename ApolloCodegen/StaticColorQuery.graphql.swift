// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
import Aida

public class StaticColorQuery: GraphQLQuery {
  public static let operationName: String = "StaticColor"
  public static let document: DocumentType = .notPersisted(
    definition: .init(
      """
      query StaticColor {
        staticColor {
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
      .field("staticColor", [StaticColor?]?.self),
    ] }

    public var staticColor: [StaticColor?]? { __data["staticColor"] }

    /// StaticColor
    ///
    /// Parent Type: `StaticDataDogColor`
    public struct StaticColor: Aida.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ParentType { Aida.Objects.StaticDataDogColor }
      public static var __selections: [Selection] { [
        .field("id", Aida.UUID.self),
        .field("valueRu", String.self),
      ] }

      public var id: Aida.UUID { __data["id"] }
      public var valueRu: String { __data["valueRu"] }
    }
  }
}
