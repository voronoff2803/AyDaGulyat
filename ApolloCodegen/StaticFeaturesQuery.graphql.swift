// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
import Aida

public class StaticFeaturesQuery: GraphQLQuery {
  public static let operationName: String = "StaticFeatures"
  public static let document: DocumentType = .notPersisted(
    definition: .init(
      """
      query StaticFeatures {
        staticFeatures {
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
      .field("staticFeatures", [StaticFeature?]?.self),
    ] }

    public var staticFeatures: [StaticFeature?]? { __data["staticFeatures"] }

    /// StaticFeature
    ///
    /// Parent Type: `StaticDataDogFeatures`
    public struct StaticFeature: Aida.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ParentType { Aida.Objects.StaticDataDogFeatures }
      public static var __selections: [Selection] { [
        .field("id", Aida.UUID.self),
        .field("valueRu", String.self),
      ] }

      public var id: Aida.UUID { __data["id"] }
      public var valueRu: String { __data["valueRu"] }
    }
  }
}
