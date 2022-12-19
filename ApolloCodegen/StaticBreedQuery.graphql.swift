// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
import Aida

public class StaticBreedQuery: GraphQLQuery {
  public static let operationName: String = "StaticBreed"
  public static let document: DocumentType = .notPersisted(
    definition: .init(
      """
      query StaticBreed {
        staticBreed {
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
      .field("staticBreed", [StaticBreed?]?.self),
    ] }

    public var staticBreed: [StaticBreed?]? { __data["staticBreed"] }

    /// StaticBreed
    ///
    /// Parent Type: `StaticDataDogBreed`
    public struct StaticBreed: Aida.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ParentType { Aida.Objects.StaticDataDogBreed }
      public static var __selections: [Selection] { [
        .field("id", Aida.UUID.self),
        .field("valueRu", String.self),
      ] }

      public var id: Aida.UUID { __data["id"] }
      public var valueRu: String { __data["valueRu"] }
    }
  }
}
