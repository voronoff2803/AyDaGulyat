// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
import Aida

public class StaticReasonQuery: GraphQLQuery {
  public static let operationName: String = "StaticReason"
  public static let document: DocumentType = .notPersisted(
    definition: .init(
      """
      query StaticReason {
        staticReason {
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
      .field("staticReason", [StaticReason?]?.self),
    ] }

    public var staticReason: [StaticReason?]? { __data["staticReason"] }

    /// StaticReason
    ///
    /// Parent Type: `StaticDataComplaintReason`
    public struct StaticReason: Aida.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ParentType { Aida.Objects.StaticDataComplaintReason }
      public static var __selections: [Selection] { [
        .field("id", Aida.UUID.self),
        .field("valueRu", String.self),
      ] }

      public var id: Aida.UUID { __data["id"] }
      public var valueRu: String { __data["valueRu"] }
    }
  }
}
