// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
import Aida

public class PageByAliasQuery: GraphQLQuery {
  public static let operationName: String = "PageByAlias"
  public static let document: DocumentType = .notPersisted(
    definition: .init(
      """
      query PageByAlias($alias: String) {
        pageByAlias(alias: $alias) {
          __typename
          id
          valueRu
          alias
          group
        }
      }
      """
    ))

  public var alias: GraphQLNullable<String>

  public init(alias: GraphQLNullable<String>) {
    self.alias = alias
  }

  public var __variables: Variables? { ["alias": alias] }

  public struct Data: Aida.SelectionSet {
    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ParentType { Aida.Objects.Query }
    public static var __selections: [Selection] { [
      .field("pageByAlias", PageByAlias?.self, arguments: ["alias": .variable("alias")]),
    ] }

    public var pageByAlias: PageByAlias? { __data["pageByAlias"] }

    /// PageByAlias
    ///
    /// Parent Type: `Page`
    public struct PageByAlias: Aida.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ParentType { Aida.Objects.Page }
      public static var __selections: [Selection] { [
        .field("id", Aida.UUID.self),
        .field("valueRu", String.self),
        .field("alias", String.self),
        .field("group", String?.self),
      ] }

      public var id: Aida.UUID { __data["id"] }
      public var valueRu: String { __data["valueRu"] }
      public var alias: String { __data["alias"] }
      public var group: String? { __data["group"] }
    }
  }
}
